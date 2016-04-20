# MRTG
mrtg multi router grapher

## NOTES 
in order to use bin/nas-zfs.pl, you have to download FREENAS-MIB.txt from your FreeNAS. It is under 
/usr/local/share/snmp/mibs/FREENAS-MIB.txt. Place it in your system (monitoring server) under
`/usr/share/snmp/mibs/`
Then just edit your snmpd.conf and add the following line:
`mibfile /usr/share/snmp/mibs/FREENAS-MIB.txt`

Then restart snmpd:
`service snmpd restart`

Make sure you edit mrtg.cfg and edit it as you wish, as this isn't "templated", specially the Target that relates to this section,
**Target[IDHERE]: \`/etc/mrtg/bin/nas-disk.pl public freenas 38\`**
`public` is the community, `freenas` the host and `38` is the OID (see below).

### COMMENTS
You could first run mrtg cfgmaker with the basenet template (considering you have apache with mrtg vhost conf under /var/www/mrtg, and mrtg cfg under /etc/mrtg):
```bash
/usr/bin/cfgmaker --global "workdir: /var/www/mrtg" --global "Options[_]: growright" --global 'Interval: 5' --global 'Refresh: 300' --if-template=basenet.template '--if-filter=$if_admin && $default_iftype' --output /etc/mrtg/mrtg.cfg public@freenas
```
^ That would create a base /etc/mrtg/mrtg.cfg with the active network interfaces ready. Then I added manual configuration to the mrtg.cfg file itself, will add it to the template in the future, but the way the mounted volumes disk stats are calculated aren't optimal to be included in a template, as you have to first calculate the Blocksize, and then multiply the Blocksize by the total disk available/used values. A mock example to get the total disk space / used space for certain volume/s would be something like the following:
```bash
for m in {1..70}; do snmpget -v2c -c public freenas_host  HOST-RESOURCES-MIB::hrStorageDescr.$m; done
```

```
...
HOST-RESOURCES-MIB::hrStorageDescr.37 = STRING: /mnt/Data
HOST-RESOURCES-MIB::hrStorageDescr.38 = STRING: /mnt/Data/MY_VOL1
HOST-RESOURCES-MIB::hrStorageDescr.39 = STRING: /mnt/Data/MY_VOL2
HOST-RESOURCES-MIB::hrStorageDescr.40 = STRING: /mnt/Data/MY_VOL3
HOST-RESOURCES-MIB::hrStorageDescr.41 = STRING: /mnt/Data/MY_VOLn
```
```bash
# snmpget -v2c -c public 192.168.4.3 HOST-RESOURCES-MIB::hrStorageType.37
HOST-RESOURCES-MIB::hrStorageType.37 = OID: HOST-RESOURCES-TYPES::hrStorageFixedDisk
```
```bash
# snmpget -v2c -c public 192.168.4.3 HOST-RESOURCES-MIB::hrStorageAllocationUnits.37
HOST-RESOURCES-MIB::hrStorageAllocationUnits.37 = INTEGER: 1024 Bytes
```
```bash
# snmpget -v2c -c public 192.168.4.3 HOST-RESOURCES-MIB::hrStorageSize.37
HOST-RESOURCES-MIB::hrStorageSize.37 = INTEGER: 1872072720
```
```bash
# snmpget -v2c -c public 192.168.4.3 HOST-RESOURCES-MIB::hrStorageUsed.37
HOST-RESOURCES-MIB::hrStorageUsed.37 = INTEGER: 104
```

Now we'd do:
`1024*1872072720 = 1917002465280 Bytes disk space for volume at .37`
`512*104 = 53248 Bytes used disk for volume at .37`

If you want the size on Gi just divide the result by /1024/1024/1024, e.g: 
`1917002465280/1024/1024/1024 = 1785.3 Gi`

We would do those calculations for every volume, but that's done with the script under bin/nas-disk.pl. The mrtg.cfg has a Target[] that includes this external script, just change the parameters to suit your context within the same mrtg.cfg file.


## Try this to run mrtg with a nice debug output:
`LANG=C LC_ALL=C /usr/bin/mrtg --debug "base" /etc/mrtg/mrtg.cfg --lock-file /var/lock/mrtg/mrtg_l --confcache-file /var/lib/mrtg/mrtg.ok`

###### NETAPP template under templates directory, looks like a nice one to modify, I have added somethings but will keep adding for netapp users
