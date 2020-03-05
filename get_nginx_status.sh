#!/bin/bash
#
# Edited on 2020.03.3 by suosuoli.cn
#

if [[ $# -eq 0 ]]; then
    echo "Usage: `basename $0` get_nginx_status.sh STATS"
fi

save_status(){
    /usr/bin/curl http://192.168.100.12/nginx_status 2> /dev/null > /tmp/nginx_status.log
}

get_port(){

    PORT=`ss -ntl | grep -w "80" | awk -F: '{print $2}' | cut -c1-2`
    if [[ "$PORT" = "80" ]]; then
        echo 1
    else
        echo 0
    fi
}

get_status(){
case $1 in
    active)
        active_conns=`/usr/bin/cat /tmp/nginx_status.log | grep -i "active" | awk '{print $3}'`;
        echo $active_conns;
;;
    accepts)
        accepts_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $1}'`;
        echo $accepts_conns;
;;
    handled)
        handled_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $2}'`;
        echo $handled_conns;
;;
    requests)
        requests_conns=`/usr/bin/cat /tmp/nginx_status.log | grep  "^ [0-9]" | awk '{print $3}'`;
        echo $requests_conns;
;;
    reading)
        reading_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $2}'`;
        echo $reading_conns;
;;
    writing)
        writing_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $4}'`;
        echo $writing_conns;
;;
    waiting)
        waiting_conns=`/usr/bin/cat /tmp/nginx_status.log | tail -n1 | awk '{print $6}'`;
        echo $waiting_conns;
;;
    port)
        get_port;
;;
esac
}

main(){
    save_status
    get_status $1
}

main $1
