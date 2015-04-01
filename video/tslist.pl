#!/usr/local/bin/perl

open (P, "ls -l $ARGV[0] |") or die ("cannot ls $ARGV[0]");

%lines = ();
while(<P>) {
    @cols=split;
    $fname = $cols[8];
    $siz = int($cols[4]/1024);
    $siz =~ s/(\d{1,3})(?=(?:\d{3})+(?!\d))/$1,/g;
    if ($fname =~ /^([a-zA-Z]{2}\d{2})_(\d+)_/) {
        # video data format
        $key = $2; 
    } else {
        $key = "zzz" . $fname;
    } 
    $lines{$key} = sprintf("%12s KB: %s\n", $siz, $fname);
}

for my $key (sort keys %lines) {
    print $lines{$key};
}
