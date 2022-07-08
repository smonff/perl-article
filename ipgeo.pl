#!/usr/bin/perl

use strict;
use warnings;

use File::Basename;
use lib dirname (__FILE__);
use SpamCheetahDBQuery;
use IO::Socket;
use JSON;
use CGI;
use Sys::Syslog;
my $q = CGI->new;
$| = 1;

openlog("GeoIP Countrywise");
print $q->header('application/json');
my $ipsock = "/tmp/ipsock";

my @ips = SpamCheetahDBQuery::dbQuery("geoip");

my %cntryHash = (), my %h = ();

for my $ip (@ips) {
    $cntryHash{$ip} += 1;
}

sub queryapi {
    my ($ip) = @_;

    my $ipjson = IO::Socket::UNIX->new(
            Type      => SOCK_STREAM,
            Peer => $ipsock);
    print $ipjson $ip . "\n";
    my $info = decode_json(<$ipjson>);
    my $cntry = $info->{'countryCode'}; 
    my $cntryName = $info->{'country'}; 
    $h{$ip} = "$cntry,$cntryName";
    syslog("info", "Country code $cntry");
}

for my $ip (keys %cntryHash) {
    queryapi($ip);
}

my %outh = ();
my %tmph = ();
for my $ip (keys(%cntryHash)) {
    my ($cntry, $name) = split /,/, $h{$ip};
    $h{$cntry} += $cntryHash{$ip};
    $outh{$cntry} = { 'value' => $h{$cntry} };
    $tmph{$name} = "$cntry,$h{$cntry}";
}

my @table = ();
for my $name (keys(%tmph)) {
    my ($code, $val) = split /,/, $tmph{$name};
    push @table, {"country" => $name,
        "code" => lc($code),
        "mails" =>  $val};
}

@table = sort { $b->{'mails'} <=> $a->{'mails'} } @table;

if($#table gt 9) {
    @table = @table[0..9];
}

my $json = JSON->new;
if ($q->param('table')) {
    print($json->canonical->pretty->encode(\@table));
} else {
    print($json->canonical->pretty->encode(\%outh));
}

