#!/bin/bash
echo "To check the Load Average"
uptime |awk '{print $8,$9,$10,$11,$12}'
echo "TO get the number of cpu core"
nproc
echo "To calculate the acceptable load average "
load= `uptime |awk '{print $12}'`
count= `nproc`
echo "acceptable load average 15minuts:=" ($load / $count * 100)
echo "NTP Finding"
echo "############################################"
ntpq -c rv
ntpstat
echo "############################################"
