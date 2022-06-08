#!/bin/bash

spark_file="$1"
#  apt-get install -qqy --no-install-recommends software-properties-common &&\
#  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 0xB1998361219BD9C9 &&\
#  apt-add-repository 'deb http://repos.azulsystems.com/debian stable main' &&\
#  add-apt-repository ppa:openjdk-r/ppa &&\

#  apt-get install openjdk-8-jre &&\


# from https://linuxize.com/post/install-java-on-debian-10/
#apt update -qqy &&\
#  apt install -y apt-transport-https ca-certificates wget dirmngr gnupg software-properties-common &&\
#  wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | apt-key add - &&\
#  add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/ &&\
#  apt update -qqy &&\
#  apt install -y adoptopenjdk-8-hotspot


# from https://stackoverflow.com/questions/57031649/how-to-install-openjdk-8-jdk-on-debian-10-buster
apt-get update -qqy &&\
  apt-get install -qqy software-properties-common &&\
  apt-add-repository --yes 'deb http://security.debian.org/debian-security stretch/updates main' &&\
  apt-get update -qqy &&
  apt-get install -qqy openjdk-8-jdk


#apt-get update -qqy &&\
#  apt-get install -qqy default-jre

apt-get update -qqy &&\
  cd /opt &&\
  curl -s ${spark_file} -o /opt/spark.tar.gz &&\
  tar xfz spark.tar.gz &&\
  rm spark.tar.gz
