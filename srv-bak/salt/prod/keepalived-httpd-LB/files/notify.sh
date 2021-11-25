#!/bin/bash

VIP=$2
sendmail (){
        subject="${VIP}'s server keepalived state is translate"
        content="`date +'%F %T'`: `hostname`'s state change to master"
        echo $content | mail -s "$subject" 2894821539@qq.com
}
case "$1" in
  master)
        httpd_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhttpd\b'|wc -l)
        if [ $httpd_status -lt 1 ];then
            systemctl start httpd
        fi
        sendmail
  ;;
  backup)
        httpd_status=$(ps -ef|grep -Ev "grep|$0"|grep '\bhttpd\b'|wc -l)
        if [ $httpd_status -gt 0 ];then
            systemctl stop httpd
        fi
  ;;
  *)
        echo "Usage:$0 master|backup VIP"
   ;;
esac
