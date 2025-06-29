#!/bin/sh

mkdir -p ./pbr
cd./pbr

# Download the first file
wget --no-check-certificate -c -O CNip1.txt https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt

# Download the second file
curl -sL https://raw.githubusercontent.com/DMF2022/ROS-cnip-script/main/cnip.rsc | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}' > CNip2.txt

# Combine both files and remove duplicates
cat CNip1.txt CNip2.txt | sort -u > CNip.txt

{
    echo "/ip firewall address-list"
    echo "add address=192.168.2.0/24 disabled=no list=CNip"
    echo "add address=183.219.57.0/24 disabled=no list=CNip"
    while read -r line; do
        address="$line"
        echo "add address=$address disabled=no list=CNip"
    done < CNip.txt
} > ../CNip.rsc

# Download the ipv6 file
curl -sL https://raw.githubusercontent.com/zealic/autorosvpn/master/chnroutes.ipv6.rsc | grep -Eo "((([0-9a-fA-F]{1,4}:){7,7}[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,7}:|([0-9a-fA-F]{1,4}:){1,6}:[0-9a-fA-F]{1,4}|([0-9a-fA-F]{1,4}:){1,5}(:[0-9a-fA-F]{1,4}){1,2}|([0-9a-fA-F]{1,4}:){1,4}(:[0-9a-fA-F]{1,4}){1,3}|([0-9a-fA-F]{1,4}:){1,3}(:[0-9a-fA-F]{1,4}){1,4}|([0-9a-fA-F]{1,4}:){1,2}(:[0-9a-fA-F]{1,4}){1,5}|[0-9a-fA-F]{1,4}:((:[0-9a-fA-F]{1,4}){1,6})|:((:[0-9a-fA-F]{1,4}){1,7}|:)|fe80:(:[0-9a-fA-F]{0,4}){0,4}%[0-9a-zA-Z]{1,}|::(ffff(:0{1,4}){0,1}:){0,1}((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])|([0-9a-fA-F]{1,4}:){1,4}:((25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])\.){3,3}(25[0-5]|(2[0-4]|1{0,1}[0-9]){0,1}[0-9])))(\/[0-9]+)?" | sort -t : -n > CNipv6.txt

{
    echo "/ipv6 firewall address-list remove [/ipv6 firewall address-list find list=CNIPv6]"
    echo "/ipv6 firewall address-list"
    while read -r line; do
        address="$line"
        echo "add address=$address disabled=no list=CNipv6"
    done < CNipv6.txt
} > ../CNIPv6.rsc

cd ..
rm -rf ./pbr
