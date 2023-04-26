#!/bin/sh

mkdir -p ./pbr
cd ./pbr

# Download the first file
wget --no-check-certificate -c -O CNip1.txt https://raw.githubusercontent.com/mayaxcn/china-ip-list/master/chnroute.txt

# Download the second file
wget --no-check-certificate -c -O CNip2.txt https://raw.githubusercontent.com/DMF2022/ROS-cnip-script/main/cnip.rsc

# Combine both files and remove duplicates
cat CNip1.txt CNip2.txt | sort -u > CNip.txt

{
echo "/ip firewall address-list"
i=0
for net in $(cat CNip.txt) ; do
  i=$((i+1))
  if [ $i -eq 2 ]; then
    echo "add address=192.168.2.0/24 disabled=no list=china-ip"
  else
    echo "add address=$net disabled=no list=china-ip"
  fi
done

} > ../CNip.rsc

cd ..
rm -rf ./pbr
