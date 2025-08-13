#run those commands on stapp02
sudo netstat -tulnp | grep 8086
#expected output :
#tcp        0      0 127.0.0.1:8086          0.0.0.0:*               LISTEN      443/sendmail: accep

sudo systemctl stop sendmail
sudo systemctl start httpd   # Now Apache should start
sudo systemctl disable sendmail   # Prevent Sendmail from restarting on reboot (optional)
sudo systemctl enable sendmail
sudo iptables -L -n
#problem :
#REJECT     all  --  0.0.0.0/0            0.0.0.0/0            reject-with icmp-host-prohibited
#solution :
sudo iptables -I INPUT 4 -p tcp --dport 8086 -j ACCEPT
