#!/usr/local/bin/perl

my @crlins;
while(<>) {
    if(m/\r/) {
	@crlines=split(/\r/);
	my $prev = "";
	my $prnext = 0;
	my $lastPrMin = "";
	foreach my $ln (@crlines) {
	    my $doprint = 0;
	    next if ($ln =~ /^\s+$/);
	    if ($ln !~ /^frame/) {
		print "$prev\n";
		$doprint = $prnext = 1;
	    } elsif ($ln =~ /(\d+):(\d+):(\d+).(\d+)/) {
		if ($2 ne $lastPrMin) {
		    $doprint = 1;
		    $lastPrMin = $2;
		}
	    } elsif ($prnext) {
		$doprint++; $prnext = 0;
	    }

	    if ($doprint) {
		print "$ln\n";
	    }
	    $prev = $ln;
	}
    }
}
