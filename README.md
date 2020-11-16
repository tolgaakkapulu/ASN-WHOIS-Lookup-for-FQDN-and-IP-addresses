# ASN WHOIS Lookup for FQDN and IP addresses

ASN and whois information is searched by querying FQDN and IP addresses with the help of dig and whois commands.

<b>Requirements</b>
- <b>CentOS</b>
   - yum install bind-utils
   - yum -y install http://repo.openfusion.net/centos7-x86_64/whois-5.2.18-1.el7.x86_64.rpm
- <b>Ubuntu/Debian</b>
   - apt-get -y install dnsutils whois
    
<b>Usage</b>
- bash fqdn_and_ip_asn_whois_lookup.sh domain.com
- bash fqdn_and_ip_asn_whois_lookup.sh X.X.X.X
