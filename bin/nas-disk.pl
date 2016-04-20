#!/usr/bin/perl

# / on FreeNAS .4.3 is at 31:
# HOST-RESOURCES-MIB::hrStorageAllocationUnits.31
# below are the volumes I gathered with 
# for m in {1..70}; do snmpget -v2c -c public 192.168.4.3  HOST-RESOURCES-MIB::hrStorageDescr.$m; done
#
# I don't check for args passed, it takes just two: community and host, e.g:
# ./script public 192.168.4.3 vol_OID_number
#
# this is information i could extract with snmpget:
#
# HOST-RESOURCES-MIB::hrStorageDescr.31 = STRING: /
# HOST-RESOURCES-MIB::hrStorageDescr.32 = STRING: /dev
# HOST-RESOURCES-MIB::hrStorageDescr.33 = STRING: /etc
# HOST-RESOURCES-MIB::hrStorageDescr.34 = STRING: /mnt
# HOST-RESOURCES-MIB::hrStorageDescr.35 = STRING: /var
# HOST-RESOURCES-MIB::hrStorageDescr.36 = STRING: /boot/grub
# ... commented .. 
#

my $community  = shift;
my $host       = shift;
my $vol        = shift;
my $blocksize  = &getblocksize();
my $total_size = &gettotsize();
my $used_size  = &getuseddisk();

# 1st line, size all in Gi (add another /1024 for TB)
print $blocksize*$total_size/1024/1024/1024, "\n";
print $blocksize*$used_size/1024/1024/1024, "\n";
print "1:23:40\n";
print "freenas.subdomain.mycompany.com\n";


sub getblocksize {
    $blocksize_str = `snmpget -v2c -c $community $host HOST-RESOURCES-MIB::hrStorageAllocationUnits.$vol 2>/dev/null`;
    $blocksize = &splitnamevalue($blocksize_str);
    $blocksize =~ s/\D//g;
    
    return $blocksize;
} 


sub gettotsize {
    $disk_tot_size = `snmpget -v2c -c $community $host HOST-RESOURCES-MIB::hrStorageSize.$vol 2>/dev/null`;
    $disk_size = &splitnamevalue($disk_tot_size);
    $disk_size =~ s/\D//g;

    return $disk_size;
}

sub getuseddisk {
    $useddisk =  `snmpget -v2c -c $community $host HOST-RESOURCES-MIB::hrStorageUsed.$vol`;
    $totused = &splitnamevalue($useddisk);
    $totused =~ s/\D//g;

    return $totused;
}


sub splitnamevalue {
    $namevalue=shift;
    chomp($namevalue);
    ($name,$value)=split(/ = /, $namevalue);


    return $value;
}
