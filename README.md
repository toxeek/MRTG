# MRTG
mrtg multi router grapher

== NOTES ==
in order to use nas-zfs.pl, you have to download FREENAS-MIB.txt from your FreeNAS. It is under 
/usr/local/share/snmp/mibs/FREENAS-MIB.txt. Place it in your system (monitoring server) under
`/usr/share/snmp/mibs/`
Then just edit your snmpd.conf and add the following line:
`mibfile /usr/share/snmp/mibs/FREENAS-MIB.txt`

Then restart snmpd:
`service snmpd restart`


`LANG=C LC_ALL=C /usr/bin/mrtg --debug "base" /etc/mrtg/mrtg.cfg --lock-file /var/lock/mrtg/mrtg_l --confcache-file /var/lib/mrtg/mrtg.ok`
