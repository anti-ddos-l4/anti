sleep 1
apt install iptables-persistent
iptables -N SAFEZONE
iptables -N IN_DPI_RULES 
iptables -N IN_CUSTOMRULES
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t raw -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -t raw -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -t raw -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -t raw -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -t raw -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -t raw -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -t raw -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -t raw -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -t raw -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
iptables -t mangle -A PREROUTING -m conntrack --ctstate INVALID -j DROP
iptables -t mangle -A PREROUTING -p tcp ! --syn -m conntrack --ctstate NEW -j DROP
iptables -t mangle -A PREROUTING -p tcp -m conntrack --ctstate NEW -m tcpmss ! --mss 536:65535 -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN,RST,PSH,ACK,URG NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,SYN FIN,SYN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,RST SYN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,RST FIN,RST -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags FIN,ACK FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,URG URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,FIN FIN -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ACK,PSH PSH -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL ALL -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL NONE -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,FIN,PSH,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags ALL SYN,RST,ACK,FIN,URG -j DROP
iptables -t mangle -A PREROUTING -p tcp --tcp-flags SYN,ACK,FIN,RST RST -m limit --limit 1/s --limit-burst 2 -j DROP
iptables -t mangle -A PREROUTING -s 224.0.0.0/3 -j DROP
iptables -t mangle -A PREROUTING -s 169.254.0.0/16 -j DROP
iptables -t mangle -A PREROUTING -s 172.16.0.0/12 -j DROP
iptables -t mangle -A PREROUTING -s 192.0.2.0/24 -j DROP
iptables -t mangle -A PREROUTING -s 10.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 0.0.0.0/8 -j DROP
iptables -t mangle -A PREROUTING -s 240.0.0.0/5 -j DROP
iptables -t mangle -A PREROUTING -s 127.0.0.0/8 ! -i lo -j DROP
iptables -t mangle -A PREROUTING -s 192.168.0.0/16 -j DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m conntrack --ctstate ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -j IN_DPI_RULES
iptables -A INPUT -j IN_CUSTOMRULES
iptables -A INPUT -j LOG --log-prefix "[IPTABLES-BLOCKED]: " --log-level 7 
iptables -A INPUT -j DROP
iptables -A IN_DPI_RULES -m conntrack --ctstate INVALID -j DROP
iptables -A IN_DPI_RULES -m conntrack --ctstate UNTRACKED -j DROP
iptables -A IN_DPI_RULES -j RETURN
/sbin/iptables -A IN_CUSTOMRULES -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --set
/sbin/iptables -A IN_CUSTOMRULES -p tcp --dport ssh -m conntrack --ctstate NEW -m recent --update --seconds 60 --hitcount 10 -j DROP
iptables -A IN_CUSTOMRULES -p tcp -m tcp --dport 22 -m conntrack --ctstate NEW -s 0.0.0.0/0 -j SAFEZONE
iptables -A IN_CUSTOMRULES -j RETURN
iptables -A IN_CUSTOMRULES -j DROP
iptables -A SAFEZONE -s 103.173.155.236/32 -j ACCEPT
iptables -A SAFEZONE -j RETURN
iptables -I INPUT -p tcp -s 103.84.76.0/22 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 115.72.0.0/13 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 117.0.0.0/13 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 125.234.0.0/15 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 171.224.0.0/11 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 203.113.128.0/18 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 220.231.64.0/18 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 27.64.0.0/12 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 116.96.0.0/12 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 125.212.128.0/17 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 125.214.0.0/18 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p tcp -s 203.190.160.0/20 -m tcp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 103.84.76.0/22 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 115.72.0.0/13 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 117.0.0.0/13 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 125.234.0.0/15 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 171.224.0.0/11 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 203.113.128.0/18 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 220.231.64.0/18 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 27.64.0.0/12 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 116.96.0.0/12 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 125.212.128.0/17 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 125.214.0.0/18 -m udp --dport 80 -j ACCEPT
iptables -I INPUT -p udp -s 203.190.160.0/20 -m udp --dport 80 -j ACCEPT
iptables-save  > /etc/iptables/rules.v4
systemctl start netfilter-persistent
systemctl restart netfilter-persistent
systemctl enable netfilter-persistent
systemctl status netfilter-persistent
clear
rm -rf anti.sh
