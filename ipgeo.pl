#!/usr/bin/perl

use File::Basename;
use lib dirname (__FILE__);
use SpamCheetahDBQuery;
use IO::Socket;
use JSON;
use CGI;
use Sys::Syslog;
$q = CGI->new;
$| = 1;

openlog("GeoIP Countrywise");
print $q->header('application/json');
$ipsock = "/tmp/ipsock";

@ips = SpamCheetahDBQuery::dbQuery("geoip");

%cntryHash = (), %h = ();

for $ip (@ips) {
    $cntryHash{$ip} += 1;
}

sub queryapi {
    ($ip) = @_;

    my $ipjson = IO::Socket::UNIX->new(
            Type      => SOCK_STREAM,
            Peer => $ipsock);
    print $ipjson $ip . "\n";
    my $info = decode_json(<$ipjson>);
    $cntry = $info->{'countryCode'}; 
    $cntryName = $info->{'country'}; 
    $h{$ip} = "$cntry,$cntryName";
    syslog("info", "Country code $cntry");
}

for $ip (keys %cntryHash) {
    &queryapi($ip);
}

%outh = ();
%tmph = ();
for $ip (keys(%cntryHash)) {
    ($cntry, $name) = split /,/, $h{$ip};
    $h{$cntry} += $cntryHash{$ip};
    $outh{$cntry} = { 'value' => $h{$cntry} };
    $tmph{$name} = "$cntry,$h{$cntry}";
}

@table = ();
for $name (keys(%tmph)) {
    ($code, $val) = split /,/, $tmph{$name};
    push @table, {"country" => $name,
        "code" => lc($code),
        "mails" =>  $val};
}

my @table = sort { $b->{'mails'} <=> $a->{'mails'} } @table;

if($#table gt 9) {
    @table = @table[0..9];
}

$json = JSON->new;
if ($q->param('table')) {
    print($json->canonical->pretty->encode(\@table));
} else {
    print($json->canonical->pretty->encode(\%outh));
}

