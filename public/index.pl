#!/usr/local/bin/perl
use Time::Local qw(timelocal);

#// 首都圏用地上デジタルチャンネルマップ
#// 識別子 => チャンネル番号
%GR_CHANNEL_MAP = (
	"GR27" => "NHK総合",
	"GR26" => "NHK教育",
	"GR25" => "日テレ",
	"GR22" => "TBS",
	"GR21" => "フジ",
	"GR24" => "テレ朝",
	"GR23" => "テレ東",
	"GR20" => "MX TV",
	"GR18" => "テレ神",
	"GR30" => "千葉",
	"GR32" => "テレ玉",
	"GR28" => "放送大学",
);

$prog=$0;
$tpl = "index.tpl";

open(TPL, "$tpl") || die "Can not open template $tpl";

$cmd = "/bin/ls -l *.mp4 |";

%vlist = ();
open($res, $cmd);

foreach(<$res>){
	@field = split;
	$sz = $field[4];
	$_ = $field[8];
    if(/^(GR\d+)_(\d+)_(\d+)_(.*)\.mp4$/) {
		$vfile = $_; chomp($vfile);
		$chan = $1;
		$start = $2;
		$end = $3;
		$title = $4;
		$szMB = int($sz/1024/1024);
		my ($sdate, $ssecux) =	&fmtdate($start, 0);
		my ($edate, $esecux) =	&fmtdate($end, 1);

		$line = sprintf("<li> <a href=\"%s\">\n", $vfile);
		$line .= sprintf("\t%s-%s :<font color=\"red\">%10s</font>: %s",
			$sdate, $edate,
			$GR_CHANNEL_MAP{$chan} ? $GR_CHANNEL_MAP{$chan} : $chan,
			$title);
		
	    $dur = $esecux - $ssecux;
		$line .= sprintf("</a> (%d MB, %d sec, %.2f KB/s(平均レート) )</li>\n", $szMB,
			$dur, $szMB * 1024 /$dur
		);

		$vlist{$start} = $line;	# to sort by start time
	}
}

# print $vlist;
foreach (<TPL>) {
	if (/%%VLIST%%/) {
		for my $prog (sort keys %vlist) {
			print $vlist{$prog};
		}
	} elsif (/%%PROG%%/) {
		printf("<div align=\"right\">\n");
#		printf("\tCreated by %s on %s\n",
#			$prog, &currentdate);
		printf("\tCreated on %s (JST)\n",
			&currentdate);
		printf("</div>\n");
	} else {
		print;
	}
}

1;

sub date2dow {
	($year, $month, $day) = @_;
#	printf("%s/%s/%s\n", $year, $month, $day);
	@weekarray = ('日','月','火','水','木','金','土');
	if ($month < 3){
		$year--;
		$month += 12;
	}
	$weeknum =
		($year+int($year/4)-int($year/100)+
		int($year/400)+int(($month*13+8)/5)+$day) % 7;
	@weekarray[$weeknum];
}

sub fmtdate {
	my $rstr;
	my $rsec = 0;
	if ($_[0] =~ /(\d{4})(\d{2})(\d{2})(\d{2})(\d{2})(\d{2})/) {
		$rsec = timelocal($6,$5,$4,$3,$2,$1,$0);
		if ($_[1]) {
			$rstr = sprintf("%s:%s", $4,$5);
		} else {
			$rstr = sprintf("%s/%s/%s(%s) %s:%s", $1,$2,$3,
				&date2dow($1,$2,$3),
				$4,$5);
		}
	} else {
		$rstr = "Error: Unknown date format: $_[0]";
	}
	return ($rstr, $rsec);
}

sub currentdate {
	my @dayofw = ('Sun', 'Mon', 'Tue', 'Wed', 'Thr', 'Fri', 'Sat');
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);
	$year += 1900;
	$mon += 1;
	sprintf("%d/%02d/%02d (%s) %d:%02d:%02d", 
		$year, $mon, $mday,  $dayofw[$wday],
		$hour, $min, $sec);
}
