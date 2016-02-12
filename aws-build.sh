#!/bin/bash -xe
sudo yum -y update

aswcliSetup
awsConfig
Ec2inst
ansible-playbook codetestplaybook.yml -f 10

function  awscliSetup() {
  echo "#################################################"
  echo "Starting the aws cli setup"
  cd
  wget --no-check-certificate https://www.python.org/ftp/python/2.7.11/Python-2.7.11.tgz
  tar xzvf Python-2.7.11.tgz && cd Python-2.7.11
  ./configure
  make && make install
  curl -O https://bootstrap.pypa.io/get-pip.py
  python get-pip.py && pip install awscli
  echo "AWS cli preparation is completed next need to configer the AWS access"
  echo "#################################################"
}

function awsConfig() {
  echo "aws configure need to access your aws environment"
  echo "#################################################"
  aws configure
  echo "Now this can check the described images we can use on the regon"
  aws ec2 describe-images --owners self amazon
  echo "#################################################"
}

function Ec2inst() {
  if [ -f my-ec2-key ]; then
  aws ec2 import-key-pair --key-name my-ec2-key --public-key-material "$(cat ~/.ssh/ec2.pub)"
  else echo "Please creaet the key useing below command"
  echo "#######ssh-keygen -t rsa -f ~/.ssh/ec2 -b 4096#######"
  fi
  echo "Started Creating security-groups name: codetestSGssh and adding the access rule"
  aws ec2 create-security-group --group-name codetestSGssh --description "Inbound ssh only from my IP"
  aws ec2 authorize-security-group-ingress --group-name codetestSGssh --cidr 10.0.0.2/32 --protocol tcp --port 22
  #aws ec2 describe-images --owners amazon --filters Name=name,Values=amzn-ami-hvm-2013.09.2.x86_64-ebs
  echo "New instance building on AWS account"
  aws ec2 run-instances --image-id ami-bba18dd2 --key-name my-ec2-key --instance-type t2.micro --security-groups codetestSGssh
}
