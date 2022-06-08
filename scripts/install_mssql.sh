#!/bin/bash

if [ "${1}" == "yes" ]; then
  echo "installing msodbcsql17 installing msodbcsql17 & freetds"
  apt-get -qqy update
  apt-get install -qqy tdsodbc unixodbc-dev
  apt-get install -qqy apt-transport-https locales gnupg tdsodbc unixodbc-dev freetds-dev freetds-bin
  apt install unixodbc -qqy
  apt-get clean -qqy
  pip3 install --upgrade pip
  echo "en_US.UTF-8 UTF-8" > /etc/locale.gen
  locale-gen
  curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add -
  curl https://packages.microsoft.com/config/debian/10/prod.list > /etc/apt/sources.list.d/mssql-release.list
  apt-get -qqy update
  ACCEPT_EULA=Y apt-get install -qqy msodbcsql17 --assume-yes
fi

