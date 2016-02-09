#!/bin/bash -xe
#This build will install LDAP and account config
echo "Starting LDAP install"
openstack server create --image OL-6.5.1-latest --flavor 5 --key-name amers1 --wait srvldap001
sudo mkdir -p /openDS

if [ -z $1 ]; then
  buildLDAP
else
  for build in "$@" ; do
    $build
  done
fi

echo " creating group and adding account"
echo ": techops_dba : ALL" >> /etc/security/access.conf
echo "%techops_dba  ALL" >> /etc/sudoers

echo "To check the NTP Stratum of created host"
cat /etc/ntp.conf |grep stratum
echo "To chek the load on the server"
uptime |awk '{print $8,$9,$10,$11,$12}'

function  buildLDAP() {
  cd
  wget http://www.openldap.org/software/download/openldap-2.4.44.tgz && tar xvzf penldap-2.4.44.tgz
  cd openldap-2.4.44
  ./config --prefix=/openDS/openldap-2.4.44 --openldapdir=/openDS/openldap-2.4.44
  make && make install
}
