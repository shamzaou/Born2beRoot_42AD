#!/bin/bash

arch=$(uname -a)

pcpu=$(grep "physical id" /proc/cpuinfo | uniq | wc -l)

vcpu=$(nproc --all)

totalmem=$(free -m | awk '$1=="Mem:" { print $2 "MB" }')
usedmem=$(free -m | awk '$1=="Mem:" { print $3 }')
percmem=$(free | awk '$1=="Mem:" {printf "%.2f%%\n", $3/$2*100 }')

dsize=$(df -h --total | tail -1 | awk '{ print $2 }')
usize=$(df -h --total | tail -1 | awk '{ printf "%.2f", $3 }')
percsize=$(df -h --total | tail -1 | awk '{ printf "%.2f%%\n", $3/$2*100 }')

cpuload=$(mpstat | tail -1 | awk '{ printf "%s%%\n", 100-$13 }')

lastboot=$(who -b | awk '{ print $3 " " $4 }')

nlvm=$(lsblk | grep "lvm" | wc -l)
iflvm=$( if [ $nlvm -eq 0 ]; then echo no; else echo yes; fi)

tcp=$(cat /proc/net/sockstat | awk '$1=="TCP:" { print $3}')
established=$(if [ $tcp -eq 0 ]; then echo "NOT ESTABLISHED"; else echo "ESTABLISHED"; fi)

userlog=$(users | wc -w)

ip=$(hostname -I)
mac=$(ip link show | awk '$1 == "link/ether" { print $2 }')

sudon=$(journalctl _COMM=sudo | grep COMMAND | wc -l)

wall  "	#Architecture : $arch
	#CPU physical : $pcpu
	#vCPU : $vcpu
	#Memory usage : $usedmem/$totalmem ($percmem)
	#Disk usage : $usize/$dsize ($percsize)
	#CPU load : $cpuload
	#Last boot : $lastboot
	#LVM use : $iflvm
	#Connections TCP : $tcp $established
	#User log : $userlog
	#Network :IP $ip ($mac)
	#Sudo : $sudon cmd"
