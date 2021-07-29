netsh interface ipv4 delete dnsservers "Ethernet" all
netsh interface ipv4 add dnsserver name="Ethernet" address=10.0.3.11 index=1 validate=no
netsh interface ipv4 add dnsserver name="Ethernet" address=10.0.3.12 index=2 validate=no
ipconfig /registerdns