#!/bin/bash

install_edb () {
  if [ ! -f "/usr/bin/psql" ]; then
    # Create edb.conf
    echo "machine apt.enterprisedb.com login ${EDB_LOGIN} password ${EDB_PASSWORD}" > /etc/apt/auth.conf.d/edb.conf

    # add edb repository and install the edb-as13-server
    echo "deb [arch=amd64] https://apt.enterprisedb.com/$(lsb_release -cs)-edb/ $(lsb_release -cs) main" > /etc/apt/sources.list.d/edb-$(lsb_release -cs).list ;
    wget -q -O - https://apt.enterprisedb.com/edb-deb.gpg.key | apt-key add -
    apt update && apt install -y edb-as13-server
    rm -rf /var/lib/apt/lists/*

    # Quick Fix (Need to improve)
    mkdir -p /var/run/edb-as/13-main.epas_stat_tmp && chown -R enterprisedb:enterprisedb  /var/run/edb-as
  fi
}

# Check credentials
if [ -z "${EDB_LOGIN}" ] && [ -z "${EDB_PASSWORD}" ]; then
  echo "ERROR: Please define EDB_LOGIN and EDB_PASSWORD"
  exit 1
else
  # Install the edb-as if is the first time
  install_edb 
  # Start the service
  su - enterprisedb -c '/usr/lib/edb-as/13/bin/edb-postgres -D /var/lib/edb-as/13/main -c config_file=/etc/edb-as/13/main/postgresql.conf'
fi

