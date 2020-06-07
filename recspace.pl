#!/usr/local/bin/perl
use strict;

#ARGV[0] Number of Recorded
#ARGV[1] Number of Reservations
my $numRecorded = 1;
my $numReserved = 1;

if (@ARGV >= 1) {
	$numRecorded = $ARGV[0];	
}
if (@ARGV >= 2) {
	$numReserved = $ARGV[1];	
}

my $df = "/bin/df";
my $du = "/usr/bin/du";
my $videoDir = "/home/www/epgrec/video";
my $cmd;
my $freeGB;
my $usedGB;
my $videoGB;

## get free space
$cmd = "$df -lm";
open (FH, "$cmd |");
while (<FH>) {
	if (m'/home$') {
		my @cols = split();
		$freeGB = $cols[3] / 1024;
		$usedGB = $cols[2] / 1024;
	}
}

## get used space
$cmd = "$du -sm $videoDir";
open (FH, "$cmd |");
while (<FH>) {
	if (m'video') {
		my @cols = split();
		$videoGB = $cols[0] / 1024;
	}
}

## show result
my $aveRecorded = $videoGB/$numRecorded;
my $moreVideos = int($freeGB/$aveRecorded) - $numReserved;
#printf("%d Recorded %.2f GB (%.2f GB ave.), %d Rserved, Free space %.2f GB (approx %d more videos)\n",
#	$numRecorded, $videoGB, $aveRecorded, $numReserved, $freeGB, $moreVideos);
printf("録画済み %d 件 %.2f GB (平均 %.2f GB)、予約済み %d 件、残容量 %.2f GB (約 %d 録画分)\n",
	$numRecorded, $videoGB, $aveRecorded, $numReserved, $freeGB, $moreVideos);
1;
