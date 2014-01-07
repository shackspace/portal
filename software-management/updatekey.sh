#!/bin/bash

publickey=`cat $2`
fingerprint=`ssh-keygen -l -f $2 | cut -d " " -f 2`

echo "update user set FirstValidDate=DATETIME('now'),'2023-05-23 23:23:23',PublicKey='${publickey}',Fingerprint='${fingerprint}' where Serialnumber='$1';" | sqlite3 shackspacekey.sql3



