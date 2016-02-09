#!/bin/bash -xe
#LDAP MON
echo "LDAP Instance status"

echo "service status"
LDAP_HOST=srvldap001
POOLING_INTERVAL=5
LOGFILE=/var/log/ldap-error.log
netstat $LDAP_HOST -pan | grep \:389 | grep LISTEN
if [ $? -eq 0]
then
  ldapsearch -v -b '' -s base -h $LDAP_HOST 'objectclass=top' namingContexts
          if [ $? -ne 0 ]; then
                  echo "`date`: Could not establish connection to LDAP server" >> $LOGFILE
else [ do nothing ]
fi
echo "chekcing the LDAP ping"
echo "############################################"
ldap-ping.pl -s $LDAP_HOST -p 389 -d 10
echo "############################################"

echo "NTP Finding"
echo "############################################"
ntpq -p
ntpstat
echo "############################################"
echo "To check the NTP Stratum of created host"
echo "############################################"
cat /etc/ntp.conf |grep stratum
echo "############################################"
echo "To the ssh access for node"
echo "############################################"
cat /etc/ssh/sshd_config |grep AllowGroups
echo "############################################"
