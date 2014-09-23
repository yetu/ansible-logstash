#!/bin/bash

#sleep 4
cat nginx_logs.txt | nc -v vagrant01 9877
cat default_logs_ok.txt | nc -v vagrant01 9123
cat default_logs_fail.txt  | nc -v vagrant01 9124