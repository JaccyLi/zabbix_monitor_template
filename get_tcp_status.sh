#!/bin/bash
#
# Edited on 2020.03.01 by suosuoli.cn
#
get_status(){
    STAT=$1
    STAT_NU=`ss -ant | \
	    awk 'NR!=1{ ++status[$1] }END{ for(stats in status) print stats, status[stats] }' | \
	    grep "${STAT}" | \
	    awk '{print $2}'`
    if [[ ${STAT_NU} -eq 0 ]]; then
        STAT_NU=0
    fi
    echo ${STAT_NU}
}

main(){
    if [[ $# -eq 0 ]]; then
        echo "Usage: ./`basename $0` tcp_status <ESTAB|LISTEN|...>"
    fi
    case $1 in
        tcp_status)
	    get_status $2;
	    ;;
    esac
}

main $1 $2
