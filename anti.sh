#!/bin/bash
curl -OL https://raw.githubusercontent.com/Swivro/ddos-protection-script/main/antiddos-debian.sh && chmod +x antiddos-debian.sh && ./antiddos-debian.sh
sleep 3
iptables -D INPUT 5
iptables -A INPUT -s 103.84.76.0/22 -j ACCEPT
iptables -A INPUT -s 115.72.0.0/13 -j ACCEPT
iptables -A INPUT -s 117.0.0.0/13 -j ACCEPT
iptables -A INPUT -s 125.234.0.0/15 -j ACCEPT
iptables -A INPUT -s 171.224.0.0/11 -j ACCEPT
iptables -A INPUT -s 203.113.128.0/18 -j ACCEPT
iptables -A INPUT -s 220.231.64.0/18 -j ACCEPT
iptables -A INPUT -s 27.64.0.0/12 -j ACCEPT
iptables -A INPUT -s 116.96.0.0/12 -j ACCEPT
iptables -A INPUT -s 125.212.128.0/17 -j ACCEPT
iptables -A INPUT -s 125.214.0.0/18 -j ACCEPT
iptables -A INPUT -s 203.190.160.0/20 -j ACCEPT
iptables -A INPUT -s 103.178.234.93 -j ACCEPT
iptables -A INPUT -s 203.162.0.0/16 -j ACCEPT
iptables -A INPUT -s 203.210.128.0/17 -j ACCEPT
iptables -A INPUT -s 221.132.0.0/18 -j ACCEPT
iptables -A INPUT -s 113.160.0.0/11 -j ACCEPT
iptables -A INPUT -s 123.16.0.0/12 -j ACCEPT
iptables -A INPUT -s 203.160.0.0/23 -j ACCEPT
iptables -A INPUT -s 222.252.0.0/14 -j ACCEPT
iptables -A INPUT -s 14.160.0.0/11 -j ACCEPT
iptables -A INPUT -s 221.132.30.0/23 -j ACCEPT
iptables -A INPUT -s 221.132.32.0/21 -j ACCEPT
iptables -A INPUT -s 103.53.252.0/22 -j ACCEPT
iptables -A INPUT -s 45.121.24.0/22 -j ACCEPT
iptables -A INPUT -s 0.0.0.0/0 -j DROP
iptables -I INPUT -s www.speedtest.net -j DROP
iptables -I INPUT -s api.fast.com -j DROP
iptables -I INPUT -s speedtest.vn -j DROP
iptables -I INPUT -s www.nperf.com -j DROP
iptables -I INPUT -s www.speedcheck.org -j DROP
iptables-save  > /etc/iptables/rules.v4
systemctl start netfilter-persistent
systemctl restart netfilter-persistent
systemctl enable netfilter-persistent
systemctl status netfilter-persistent
rm -rf antiddos-debian.sh
rm -rf anti.sh
clear
echo "Đã Hoàn Tất!"
