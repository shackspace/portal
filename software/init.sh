#!/bin/sh
echo "open:x:1338:1338:open the door,,,:/mmc/open:/mmc/open/open.sh" >>/etc/passwd
echo "close:x:1338:1338:close the door,,,:/mmc/close:/mmc/close/close.sh" >>/etc/passwd
echo "openclose:x:1338:" >>/etc/group

cp /mmc/root.pub /etc/dropbear/authorized_keys
chmod 600 /etc/dropbear/authorized_keys

echo "/mmc/open/open.sh" >>/etc/shells
echo "/mmc/close/close.sh" >>/etc/shells

chown -R open:openclose /mmc/open
chown -R open:openclose /mmc/close

touch /tmp/access.log
chown open:openclose /tmp/access.log


sleep 1
stty -F /dev/ttyS0 9600
sleep 1
stty -F /dev/ttyS0 cs8
sleep 1
stty -F /dev/ttyS0 -parenb -crtscts -ixon -clocal -cstopb -echo
sleep 1

chown open:openclose /dev/ttyS0

cat /mmc/motd >/etc/banner

