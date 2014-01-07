#!/bin/bash

# 1 Serialnumber
# 2 Givenname
# 3 Surname
# 4 public key

echo "CREATE TABLE IF NOT EXISTS user (Givenname varchar(64), Surname varchar(64),serialnumber varchar(64),Created timestamp DEFAULT CURRENT_TIMESTAMP,FirstValidDate timestamp,LastValidDate timestamp,PrivateKey varchar(3300),PublicKey varchar(730),Fingerprint varchar(64));" | sqlite3 shackspacekey.sql3

#ssh-keygen -b 4096 -t rsa -f output -N "" -C "$1"

publickey=`cat $4`
#privatekey=`cat output`
fingerprint=`ssh-keygen -l -f $4 | cut -d " " -f 2`

echo "insert into user (Givenname,Surname,Serialnumber,FirstValidDate,LastValidDate,PrivateKey,PublicKey,Fingerprint) VALUES ('$2','$3','$1',DATETIME('now'),'2023-05-23 23:23:23','${privatekey}','${publickey}','${fingerprint}');" | sqlite3 shackspacekey.sql3

#rm output
#rm output.pub


