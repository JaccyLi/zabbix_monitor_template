#!/bin/bash
#
# Edited by suosuoli.cn on 2020.03.05
#

WORK_DIR="/usr/local/src"
ZABBIX_VER="zabbix-4.0.15"

if [[ ! -e "${WORK_DIR}" ]]; then
    WORK_DIR=`pwd`
fi

## install some libs and deps.
if grep -iq "ubuntu" /etc/issue; then
    apt update
    apt -y install iproute2 ntpdate tcpdump telnet 
    apt -y install traceroute nfs-kernel-server nfs-common lrzsz tree 
    apt -y install openssl libpcre3 zlib1g-dev 
    apt -y install tcpdump telnet traceroute gcc openssh-server 
    apt -y install libssl-dev libpcre3-dev  
    apt -y install zlib1g-dev iotop unzip zip make
else
    yum install -y vim iotop bc gcc gcc-c++ glibc glibc-devel  
    yum install -y pcre  pcre-devel openssl  openssl-devel zip unzip zlib-devel
    yum install -y net-tools lrzsz tree ntpdate telnet lsof tcpdump wget libevent 
    yum install -y libevent-devel bc systemd-devel bash-completion traceroute 
fi


## compile zabbix and install 
cd ${WORK_DIR}
tar -xf ${ZABBIX_VER}.tar.gz && \
            cd ${ZABBIX_VER} && \
            ./configure --prefix=/apps/zabbix_agent --enable-agent && \
            make && make install

## add user and create dir for pid file and log file 
useradd zabbix
mkdir /apps/zabbix_agent/pid
mkdir /apps/zabbix_agent/logs

# copy conf file to the app folder
\cp ${WORK_DIR}/zabbix-agent.service    /lib/systemd/system/zabbix-agent.service
\cp ${WORK_DIR}/zabbix_agentd.conf      /apps/zabbix_agent/etc/zabbix_agentd.conf
\cp ${WORK_DIR}/zabbix_agentd.conf.d/*  /apps/zabbix_agent/etc/zabbix_agentd.conf.d/

## modify the zabbix hostname to ip.
HOST_IP=`ifconfig  eth0 | grep -w inet  | awk '{print $2}'`
sed -i "s/Hostname=/Hostname=${HOST_IP}/g" /apps/zabbix_agent/etc/zabbix_agentd.conf

chown zabbix.zabbix -R /apps/zabbix_agent/

systemctl daemon-reload
systemctl enable zabbix-agent
systemctl restart zabbix-agent
