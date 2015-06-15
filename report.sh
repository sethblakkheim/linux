#!/bin/bash

#fecha=`date +%Y-%m-%d` #fecha customizada` 
fecha=`date +%d-%m-%Y`
os=`cat /etc/redhat-release` #muestra el sistema operativo
#lastigm=`find /home/igm/public_html -mtime -1 -ls|sort -k1 -r -n` #encuentra los archivos modificados en las ultimas 24 hrs.
#queuedmail=`/usr/sbin/exim -bpc` #
diskstat=`df -lhT`
lastaccess=`last -x|head -n 4` #muestra los ultimos 4 accesos al server
raid=`cat /proc/mdstat` #muestra el raid
proc=`ps aux | sort -k 3,3 -r | head -n 6` #muestra los 6 procesos mas pesados actuales
login=`/usr/bin/w` #muestra quien está con sesiones abiertas en el serveri
activeconn=`netstat -an|grep :80|grep ESTABLISHED|sort|uniq -u -c`
hostname=`hostname`
line=`echo -e "***********************************************"`
kernel=`uname -r`
machine=`uname -m`
#ebury=`ssh -G 2>&1 | grep -e illegal -e unknown > /dev/null && echo “No” || echo “Si`
ip=`ifconfig |grep -i 'inet addr:'|head -n3|cut -d: -f2|awk '{print $1}'|sort`
hora=`date|awk '{print $4}'`
mem=`free -m`
ports=`nmap -sS 127.0.0.1|tail -n 21`
var66=`netstat -an|grep :80|grep ESTABLISHED|sort|uniq -u -c|wc -l`
httpd=`ps ax|grep httpd|cut -d: -f2|sort|uniq -d|wc -l > apache.txt|cat apache.txt`
httpd2=`if [ "$httpd" == 0 ]; then 
	echo -e "Apache?: Down :(!!" 
else 
	echo -e "Apache?: Up :D" 
fi`
mysql=`ps ax|grep /usr/sbin/mysqld|cut -d: -f2|sort|uniq -d|wc -l > mysql.txt|cat mysql.txt`
mysql2=`if [ "$mysql" == 0 ]; then
        echo -e "MySql?: Down :(!!"
else
        echo -e "MySql?: Up :D"
fi`

exim=`ps ax|grep /usr/sbin/exim|cut -d: -f2|sort|uniq -d|wc -l > exim.txt|cat exim.txt`
exim2=`if [ "$exim" == 0 ]
then
        echo -e "Exim?: Down :(!!"
else
        echo -e "Exim?: Up :D"
fi`

sshd=`ps ax|grep /usr/sbin/sshd|cut -d: -f2|sort|uniq -d|wc -l > sshd.txt|cat sshd.txt`
sshd2=`if [ "$sshd" == 0 ]
then
        echo -e "Ssh?: Down :(!!"
else
        echo -e "Ssh?: Up :D"
fi`

named=`ps ax|grep /usr/sbin/named|cut -d: -f2|sort|uniq -d|wc -l > named.txt|cat named.txt`
named2=`if [ "$named" == 0 ]
then
        echo -e "Named?: Down :(!!"
else
        echo -e "Named?: Up :D"
fi`

ebury=`ssh -G 2>&1 | grep -e illegal -e unknown > /dev/null && echo No || echo Si|wc -l`
ebury1=`if [ "$ebury" == No ]
then
	echo -e "Tenemos ebury?: El server no esta infectado !! :D"
else
	echo "Tenemos ebury?: Si :/"
fi`

lfd=`ps ax|grep "lfd -sleeping"|sort|uniq -u |tail -n 1|wc -l`
lfd1=`if [ "$lfd" -eq 0 ]
then
        echo -e "Firewall Lfd arriba?: NO :(!!"
else
        echo -e "Firewall Lfd arriba?: Up :)"
fi`


tomcat=`ps ax|grep -i "/usr/bin/java"|sort|uniq -u|head -n1|wc -l`
tomcat1=`if [ "$tomcat" -eq 0 ]
then
	echo -e "Tomcat Apache?: NO!!!!"
else
	echo -e "Tomcat Apache?: Si :)"
fi`

mysqlproc=`mysqladmin -u root processlist`
###########################################################################################################################
echo "
Creando reporte para $hostname con fecha $fecha. 
Hora del reporte: $hora. Hora del servidor: $hora. 
El servidor esta corriendo actualmente Linux $os. 
La version del kernel es $kernel. 
La Arquitectura del sistema es $machine. 
El server tiene las siguientes direcciones ip:
$ip

$line
*** Comprobacion de daemons en el servidor ***

$tomcat1
$httpd2
$mysql2
$exim2
$named2
$sshd2
$lfd1
$line

*** Ebury SSH Rootkit ***

$ebury1
$line

*** Puertos abiertos en $hostname ***

$ports
$line
*** Usuarios actualmente conectados en el server ***

$login
$line
*** Ultimos accesos al servidor $hostname ***

$lastaccess
$line
*** Procesos mas pesados en $hostname ***

$proc
$line

*** Consultas y procesos actuales en MySql ***
$mysqlproc
$line

*** Conexion al puerto 80 al momento de la revision (Revision de DDoS) ***

$activeconn

*** Total de conexiones a la hora de la revision: $var66 ***
$line

*** Estados de los Discos y Filesystems ***

$diskstat
$line
*** Estado del RAID ***

$raid
$line

Reporte terminado a las $hora con fecha $fecha" | mail -s "Reporte Diario Servidor $hostname a las $hora" soporte@dnet.cl

