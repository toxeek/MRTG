#!/usr/bin/perl


my $community  = shift;
my $host       = shift;

my $reads_per_sec  = &getreads();
my $writes_per_sec = &getwrites();

print "$reads_per_sec\n";
print "$writes_per_sec\n";
print "1:23:40\n";
print "freenas.subdomain.mycompany.com\n";


sub getreads {
    $reads_str = `snmpget -v2c -c $community $host FREENAS-MIB::zfsPoolOpRead1sec.1 2>/dev/null`;
    $reads = &splitnamevalue($reads_str);
    $reads =~ s/\D//g;
    
    return $reads;
} 


sub getwrites {
    $writes_str = `snmpget -v2c -c $community $host FREENAS-MIB::zfsPoolOpWrite1sec.1 2>/dev/null`;
    $writes = &splitnamevalue($writes_str);
    $writes =~ s/\D//g;

    return $writes;
}

sub splitnamevalue {
    $namevalue=shift;
    chomp($namevalue);
    ($name,$value)=split(/ = /, $namevalue);
    $value =~  s/Counter64//g;    

    return $value;
}
