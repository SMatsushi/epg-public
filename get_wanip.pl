#!/usr/local/bin/perl

use strict;
use warnings;
use LWP::UserAgent;
use HTML::TreeBuilder;

# urlを指定する
# my $url = 'http://www.yahoo.co.jp';

# URL to get WAN Address

# my $url = 'http://echoip.com';
my $url = 'http://checkip.dyndns.org';
# my $url = 'http://checkip.dyndns.com';

# IE8のフリをする
my $user_agent = "Mozilla/4.0 (compatible; MSIE 8.0; Windows NT 6.1; Trident/4.0)";

# LWPを使ってサイトにアクセスし、HTMLの内容を取得する
my $ua = LWP::UserAgent->new('agent' => $user_agent);
my $res = $ua->get($url);
my $content = $res->content;

# print $content;
# exit 0;
# HTML::TreeBuilderで解析する
my $tree = HTML::TreeBuilder->new;
$tree->parse($content);

# DOM操作してトピックの部分だけ抜き出す。
# <div id='topicsfb'><ul><li>....の部分を抽出する

# my @items =  $tree->look_down('id', 'topicsfb')->find('li');
my @items =  $tree->find('body');
print "WAN: ";                    
print $_->as_text."\n" for @items;                    
