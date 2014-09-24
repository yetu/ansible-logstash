#!/bin/bash
set -e

echo "pwd"
pwd
echo "ls -l"
ls -l 

cd tests
echo "ls -l"


sleep 4
cat nginx_logs.txt | nc -v localhost 9877
cat default_logs_ok.txt | nc -v localhost 9123
cat default_logs_fail.txt  | nc -v localhost 9124

echo "/tmp ls"
ls -l /tmp

echo "java ps"
ps aux | grep java
other=$(cat /tmp/logstash_all_others.txt | wc -l)
default_tcp=$(cat /tmp/logstash_default_tcp_9124_match_ok.txt | wc -l)
nginx_fail=$(cat /tmp/logstash_nginx_9877_match_fail.txt | wc -l)
nginx_ok=$(cat /tmp/logstash_nginx_9877_match_ok.txt | wc -l )

test_pass(){
	if [ $1 -nq $2 ]; then
		echo " [Failed]"
		exit 1
	else
		echo " [Ok]"
}

echo -n "All other logs : "
test_pass $other 1

echo -n "Default tcp logs : "
test_pass $default_tcp 1

echo -n "Nginx Fail logs : "
test_pass $nginx_fail 1

echo -n "Nginx Ok logs : "
test_pass $nginx_ok 2
