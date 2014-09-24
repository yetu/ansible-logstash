#!/bin/bash
set -e

echo "sleep 30 to make sure logstash is up"
sleep 30
cd  tests
cat nginx_logs.txt | nc -v localhost 9877
cat default_logs_ok.txt | nc -v localhost 9123
cat default_logs_fail.txt  | nc -v localhost 9124

echo "sleep 30 to make sure logstash parsed data "
sleep 30

other=$(cat /tmp/logstash_all_others.txt | wc -l)
default_tcp=$(cat /tmp/logstash_default_tcp_9124_match_ok.txt | wc -l)
nginx_fail=$(cat /tmp/logstash_nginx_9877_match_fail.txt | wc -l)
nginx_ok=$(cat /tmp/logstash_nginx_9877_match_ok.txt | wc -l )

test_pass () {
	if [ $1 -ne $2 ]; then
		echo " [Failed]"
        exit 1
    else
		echo " [Ok]"
    fi
}

echo -n "checking default tcp logs : "
test_pass $default_tcp 1

echo -n "checking nginx Fail logs : "
test_pass $nginx_fail 1

cat /tmp/logstash_nginx_9877_match_ok.txt
echo -n "checking  nginx Ok logs : "
test_pass $nginx_ok 2