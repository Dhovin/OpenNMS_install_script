#!/bin/bash

sudo apt update -y
sudo apt upgrade -y
#prep for postgresql install
sudo apt install -y postgresql-common
sudo /usr/share/postgresql-common/pgdg/apt.postgresql.org.sh
#install postgresql 15
sudo apt -y install postgresql-15

sudo -u postgres createuser -P opennms
sudo -u postgres createdb -O opennms opennms
sudo -u postgres psql -c "ALTER USER postgres WITH PASSWORD 'YOUR-POSTGRES-PASSWORD';"
sudo apt -y install curl gnupg ca-certificates
curl -fsSL https://debian.opennms.org/OPENNMS-GPG-KEY | sudo gpg --dearmor -o /usr/share/keyrings/opennms.gpg
echo "deb [signed-by=/usr/share/keyrings/opennms.gpg] https://debian.opennms.org stable main" | sudo tee /etc/apt/sources.list.d/opennms.list
sudo apt update
sudo apt -y install opennms
./usr/share/opennms/bin/install

#Setup password key store
sudo -u opennms /usr/share/opennms/bin/scvcli set postgres opennms password
sudo -u opennms /usr/share/opennms/bin/scvcli set postgres-admin postgres password

#open postgresql connection config file
sudo -u opennms vi /usr/share/opennms/etc/opennms-datasources.xml

#detect java install
sudo /usr/share/opennms/bin/runjava -s
