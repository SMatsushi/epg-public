#!/usr/local/bin/perl
use strict;

#ARGV[0] Target TS File
#ARGV[1] Output Filename
#ARGV[2] Video Size (Ex. 480x360 960x720)

# my $cmd = "/usr/bin/ffmpeg";
# my $ffpreset = "/var/www/html/epgrec/libx264-hq-ts.ffpreset";
my $cmd = "/usr/local/bin/ffmpeg";
my $ffpreset = "/home/www/epgrec/libx264.ffpreset";

my $str;
my @lines;
my $br; #Audio BitRate
my ($vstr,$astr); #save StreamID

$str = `$cmd -i $ARGV[0] 2>&1`;

@lines = split(/\n/,$str);
foreach(@lines){
    #Get Video StreamID
    if($_ =~ /\#([0-9\.]+)\[.+mpeg2video/ && $vstr eq ""){
	$vstr = $1;
    }
    #Get Audio StreamID
    elsif($_ =~ /\#([0-9\.]+)\[.+Audio.+, ([0-9]+) kb\/s/){
	if($2 > $br){
	    $astr = $1;
	    $br = $2;
	}
    }
}

print "$vstr $astr\n";

#Encode
#`$cmd -i $ARGV[0] -y -f mp4 -vcodec libx264 -fpre $ffpreset -r 30000/1001 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -map $vstr -map $astr -threads 4 $ARGV[1]`;
#`$cmd -i $ARGV[0] -y -f mp4 -r 30000/1001 -aspect 16:9 -s $ARGV[2] -bufsize 2000k -maxrate 5000k -vsync 1 -acodec libfaac -ac 2 -ar 48000 -ab 128k -threads 4 $ARGV[1]`;
# `$cmd -i $ARGV[0] -y -aspect 16:9 -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]`;
`$cmd -i $ARGV[0] -y -s $ARGV[2] -vsync 1 -threads 4 $ARGV[1]`;

1;
