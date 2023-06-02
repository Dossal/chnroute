#!/bin/sh

mkdir -p ./pbr
cd ./pbr

# Download the first file
wget --no-check-certificate -c -O CNip1.txt https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt

# Download the second file
curl -sL https://raw.githubusercontent.com/DMF2022/ROS-cnip-script/main/cnip.rsc | grep -Eo '([0-9]{1,3}\.){3}[0-9]{1,3}/[0-9]{1,2}' > CNip2.txt

# Combine both files and remove duplicates
cat CNip1.txt CNip2.txt | sort -u > CNip.txt

{
echo "/ip firewall address-list"
echo "add address=192.168.2.0/24 disabled=no list=china-ip"
echo "add address=183.219.57.0/24 disabled=no list=china-ip"
for net in $(cat CNip.txt) ; do
  echo "add address=$net disabled=no list=china-ip"
done
    
} > ../CNip.rsc

cd ..
rm -rf ./pbr
