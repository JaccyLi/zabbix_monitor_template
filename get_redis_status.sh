#!/bin/bash
#
# Edited on 2020.03.02 by suosuoli.cn
#


get_redis_status(){
echo -en "INFO \r\n" | ncat 127.0.0.1 $1 | grep -w "$2" | awk -F: '{print $2}'
}

main(){
	# install ncat if not installed
    cat /etc/issue | grep -iq "ubuntu"
    [[ $? -ne 0 ]] && yum install nmap-ncat -y &> /dev/null || apt install nmap-ncat -y &> /dev/null

	# prompt usage
    if [[ $# -eq 0 ]]; then
        echo "`basename $0` redis_status <PORT> <STATUS>"
    fi

	# do the f* thing
    if [[ $1 = "redis_status" ]]; then
        get_redis_status $2 $3
    fi
}

main $1 $2 $3
