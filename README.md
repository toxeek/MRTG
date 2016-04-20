# MRTG
mrtg multi router grapher

## NOTES 
in order to use nas-zfs.pl, you have to download FREENAS-MIB.txt from your FreeNAS. It is under 
/usr/local/share/snmp/mibs/FREENAS-MIB.txt. Place it in your system (monitoring server) under
`/usr/share/snmp/mibs/`
Then just edit your snmpd.conf and add the following line:
`mibfile /usr/share/snmp/mibs/FREENAS-MIB.txt`

Then restart snmpd:
`service snmpd restart`

### COMMENTS
You would first run mrtg cfgmaker with the basenet template (considering you have apache with mrtg vhost conf under /var/www/mrtg, and mrtg cfg under /etc/mrtg):
`/usr/bin/cfgmaker --global "workdir: /var/www/mrtg" --global "Options[_]: growright" --global 'Interval: 5' --global 'Refresh: 300' --if-template=basenet.template '--if-filter=$if_admin && $default_iftype' --output /etc/mrtg/mrtg.cfg public@freenas`


`LANG=C LC_ALL=C /usr/bin/mrtg --debug "base" /etc/mrtg/mrtg.cfg --lock-file /var/lock/mrtg/mrtg_l --confcache-file /var/lib/mrtg/mrtg.ok`
