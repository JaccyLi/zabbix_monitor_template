#!/bin/bash
#
# Edited on 2020.03.02 by suosuoli.cn
#
# ubuntu : apt install nmap  -----> ncat

	# get status
get_memcached_status(){
echo -e "stats\nquit" | ncat 127.0.0.1 "$1" | grep "STAT $2" | awk '{print $3}'
}

main(){
	# prompt usage
    if [[ $# -eq 0 ]]; then
        echo "Usage: `basename $0` get_memcached_status <port> <status>"
    fi

	# install nmap if not installed. 
    cat /etc/issue | grep -iq "ubuntu" 2>&1 /dev/null
    if [[ $? -ne 0 ]]; then
        yum install -y nmap &> /dev/null
    else
        apt update &> /dev/null && apt install -y nmap &> /dev/null
    fi

	# get status
    if [[ $1 = "mem_status" ]]; then
        get_memcached_status $2 $3
    fi
}

main $1 $2 $3
