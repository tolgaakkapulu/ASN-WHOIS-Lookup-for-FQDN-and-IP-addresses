#!/bin/bash

function valid_ip()
{
    local  ip=$1
    local  stat=1

    if [[ $ip =~ ^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$ ]]; then
        OIFS=$IFS
        IFS='.'
        ip=($ip)
        IFS=$OIFS
        [[ ${ip[0]} -le 255 && ${ip[1]} -le 255 \
            && ${ip[2]} -le 255 && ${ip[3]} -le 255 ]]
        stat=$?
    fi
    return $stat
}

INPUT=$1

if valid_ip $INPUT
then 
	echo -e "==================="
	echo -e "  $INPUT"
	echo -e "===================\n"

	whois -a $INPUT  2>/dev/null
else
	fqdn_to_IP_file="/tmp/fqdn_to_IP.tmp"
	fqdn_to_IP_count=`dig +short $INPUT 2>/dev/null | grep -E -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' | wc -l`

	if [ $fqdn_to_IP_count -eq 0 ]
	then
		echo -e "Invalid address. Please check the address.\n"
		exit

	elif [ $fqdn_to_IP_count -gt 1 ]
	then
		dig +short $INPUT 2>/dev/null | grep -E -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' > $fqdn_to_IP_file
		echo -e "============================================================================================================================="
		echo -en "  $INPUT : "

		while read -r line
		do
			echo -n "$line | "
		done < $fqdn_to_IP_file

		echo -e "\n============================================================================================================================="
		echo -e "  $fqdn_to_IP_count IP addresses were found connected to the \"$INPUT\" address. The first 1 of the IP addresses are included in the list."	
		echo -e "=============================================================================================================================\n"	

		fqdn_to_IP=`head -n1 $fqdn_to_IP_file`
	else 
		echo -e "========================================================================"
		echo -e "  $fqdn_to_IP_count IP addresses were found connected to the \"$INPUT\" address."
		echo -e "========================================================================\n"
		
		dig +short $INPUT 2>/dev/null | grep -E -o '^[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}$' > $fqdn_to_IP_file
		fqdn_to_IP=`cat $fqdn_to_IP_file`
	fi

	echo -e "==================="
	echo -e "  $fqdn_to_IP"
	echo -e "===================\n"
		
	timeout 30 whois -a $fqdn_to_IP 2>/dev/null

	if (($? == 124))
	then 
		echo -e "\nTimeout. Please try again.\n"
	fi
	rm $fqdn_to_IP_file
fi
