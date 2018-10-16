#!/bin/bash
# @LiYanzhe 20180822
#colors

SEQ="\x1b["
GREEN=$SEQ"32;01m"
RED=$SEQ"31;01m"
RESET=$SEQ"39;49;00m"

ip=10
num=1
excluds=(35 36 37 38 39 64 65 73 74 75 76 78 80 82 84 86 88 99 100)

if [ ! -n "$1" ] ; then
	echo -e "$RED[error]$RESET Input the network segment"
	echo -e "$GREEN Usage: testip.sh (segment) [ping_number] $RESET"
	exit 1
fi
if [ -n "$2" ] ; then
	num=$2
fi

segment="$1."
while [ $ip != "101" ]; do
	ip=`expr "$ip" "+" "1"`
	if [[ "${excluds[@]}" =~ "$ip" ]] ; then
		continue
	fi
	ping $segment$ip -c $num | grep -q "ttl=" && echo -e "$segment$ip\t\t$GREEN[ok]$RESET" || echo -e "$segment$ip\t\t$RED[error]$RESET"
done
