#!bin/bash
ARCH=$(uname -a)
P_CPU=$(grep 'physical id' /proc/cpuinfo | uniq | wc -l)
V_CPU=$(grep 'processor' /proc/cpuinfo | uniq | wc -l)
CPU=$(top -bn1 | grep '^%Cpu' | cut -c 9- | xargs | awk '{printf("%.1f%%"), $1 + $3}')
F_RAM=$(free -m | grep 'Mem:' | awk '{print $2}')
U_RAM=$(free -m | grep 'Mem:' | awk '{print $3}')
P_RAM=$(free -m | grep Mem: | awk '{printf("%.2f"), $3/$2*100}')
F_DISK=$(df -Bg | grep '^/dev/' | grep -v /boot | awk '{fd += $2} END {print fd}')
U_DISK=$(df -Bm | grep '^/dev/' | grep -v /boot | awk '{ud += $3} END {print ud}')
P_DISK=$(df -Bm | grep '^/dev/' | grep -v /boot | awk '{ud += $3} {fd += $2} END {printf("%d"), ud/fd*100}')
L_BOOT=$(who -b | awk '$1 == "system" {print $3 " " $4}')
LVM_SUM=$(lsblk | grep "lvm" | wc -l)
LVM=$(if [ ${LVM_SUM} -eq 0 ]; then echo "no"; else echo "yes"; fi)
# install net-tools
TCP=$(cat /proc/net/sockstat{,6} | awk '$1 == "TCP:" {print $3}')
TCPMSSG=$(if [ ${TCP} -eq 0 ]; then echo NOT ESTABLISHED; else echo ESTABLISHED; fi)
USERLOG=$(users | wc -w)
IP=$(hostname -I)
MAC=$(ip link show | awk '$1 == "link/ether" {print $2}')
CMDS=$(journalctl -q _COMM=sudo | grep COMMAND | wc -l)
echo "    #Architecture: ${ARCH}"
echo "    #CPU physical: ${P_CPU}"
echo "    #vCPU: ${V_CPU}"
echo "    #Memory Usage: ${U_RAM}/${F_RAM}MB (${P_RAM}%)"
echo "    #Disk Usage: ${U_DISK}/${F_DISK}Gb (${P_DISK}%)"
echo "    #CPU load: ${CPU}"
echo "    #Last boot: ${L_BOOT}"
echo "    #LVM use: ${LVM}"
echo "    #Connections TCP: ${TCP} ${TCPMSSG}"
echo "    #User log: ${USERLOG}"
echo "    #Network: IP ${IP} (${MAC})"
echo "    #Sudo: ${CMDS} cmd"
