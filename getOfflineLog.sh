#!/bin/sh
logpath=$1
logtype=$2
if [ ! $logpath ]; then
  echo "logpath is  NULL,Please input correct logpath ,for example:sh getOfflineLog.sh /paasdata/op-tenant/ranoss/otcp/logs .log"
  exit
fi 

if [ ! $logtype ]; then
  echo "logpath is  NULL,default value is .log"
  logtype=.log
fi 

cur_dir=$(cd `dirname $0`; pwd)

currenttime=`date +"%Y%m%d%H%M%S"`
offlinelog=$cur_dir/offlinelog/$currenttime


#创建日志文件目录
mkdir -p $offlinelog
recordLog=$offlinelog/recordLog.log

iparray=`pdm-cli node list|grep net_api_v4: |cut -d ':' -f 2 |cut -d ',' -f 1|sort |uniq`
if [ ! $iparray ]; then
  echo "iparray is  NULL,exit"| tee -a $recordLog

else
  echo "iparray is NOT NULL"| tee -a $recordLog
  break
fi

echo $iparray| tee -a $recordLog
for element in $iparray
do
echo "ipinfo is $element"| tee -a $recordLog
ip=`echo $element | grep -E -o "[0-9]+\.[0-9]+\.[0-9]+\.[0-9]+"`
echo "ip is $ip"| tee -a $recordLog

if [ ! $ip ]; then
  echo "ipinfo is $element,ip is  NULL,continue"
  continue
fi 
remotefile=`ssh ubuntu@$ip "cd $logpath ; ls -lRt |grep -v ^d|grep $logtype"`
echo $ip|tee -a $recordLog
echo $remotefile|tee -a $recordLog
done



