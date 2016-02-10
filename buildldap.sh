#!/bin/bash -xe
#This build will install LDAP and account config
host1=srvldap001
host2=srvldap002

echo "Starting LDAP install"
openstack server create --image OL-6.5.1-latest --flavor 5 --key-name amers1 --wait srvldap001
sudo mkdir -p /openDS
buildLDAP

echo " creating group and adding account"
echo "+ : techops_dba : ALL" >> /etc/security/access.conf
echo "techops_dba  ALL= ALL" >> /etc/sudoers

echo "To check the NTP Stratum of created host"
cat /etc/ntp.conf |grep stratum
ntpq -c rv
echo "To chek the load on the server"
uptime |awk '{print $8,$9,$10,$11,$12}'

if [`hosname` == $host2]; then
echo "Add the scurity group to access"
echo "AllowGroups techops_dba" >> /etc/ssh/sshd_config
fi


function  buildLDAP() {
  cd
  wget http://www.openldap.org/software/download/openldap-2.4.44.tgz && tar xvzf openldap-2.4.44.tgz
  cd openldap-2.4.44
  ./config --prefix=/openDS/openldap-2.4.44 --openldapdir=/openDS/openldap-2.4.44
  make && make install
}
