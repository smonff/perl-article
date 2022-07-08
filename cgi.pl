use JSON;
use CGI;
use DBI;
use IO::Socket;
use Sys::Syslog;
use JSON;
 
$q = CGI->new;
print $q->header('application/json');
openlog("Dashboard");
$json = JSON->new;
my $proxysock = "/tmp/proxysock";
my $db = DBI->connect("dbi:Pg:host=/tmp", "postgres", undef, {AutoCommit
=> 1});
 
if(!defined($db)) {
	print("error","Could not connect to Postgres db");
}
sub getstats {
	my $proxy = IO::Socket::UNIX->new(
			Type      => SOCK_STREAM,
			Peer => $proxysock);
	print $proxy "DUMPSTATS";
 
	@out = <$proxy>;
	for(@out) {
		chomp;
		($parm,$n) = split/=/;
		if ($parm eq "totalmailattemptcnt") {
			$outh{"mails"}= $n;
		} elsif ($parm eq "goodmailcnt") {
			$outh{"goodmail"} = $n;
		} elsif ($parm eq "numattcnt") {
			$outh{"numatt"} =$n;
		} elsif ($parm eq "regexcnt") {
			$outh{"regmatch"} =$n;
		} elsif ($parm eq "viruscnt") {
			$outh{"viruses"} = $n;
		} elsif ($parm eq "spamcnt") {
			$outh{"spamcnt"} = $n;
		} elsif ($parm eq "relaydeniedcnt") {
			$outh{"relaydenied"} = $n; 
		} elsif ($parm eq "bannedrecipcnt") {
			$outh{"badrecip"} =$n; 
		} elsif ($parm eq "bannedsendercnt") {
			$outh{"badsender"} = $n; 
		} elsif ($parm eq "blockedmimecnt") {
			$outh{"badatt"} = $n; 
		} elsif ($parm eq "rfcrejcnt") {
			$outh{"rfcrej"} = $n; 
		} elsif ($parm eq "fqdnrejcnt") {
			$outh{"fqdnrej"} = $n; 
		} elsif ($parm eq "dkimrejcnt") {
			$outh{"dkimrej"} = $n; 
		} elsif ($parm eq "spfrejcnt") {
			$outh{"spfrej"} = $n; 
		} elsif ($parm eq "helorejcnt") {
			$outh{"helorej"} = $n; 
		} elsif ($parm eq "mailszcnt") {
			$outh{"mailszrej"} = $n; 
		} elsif ($parm eq "rblrejcnt") {
			$outh{"rblrej"} = $n; 
		} elsif ($parm eq "score") {
			$outh{"score"} = $n; 
		} elsif ($parm eq "sender_nomx") {
			$outh{"sender_nomx"} = $n; 
		} elsif ($parm eq "norevdns") {
			$outh{"norevdns"} = $n; 
		} elsif ($parm eq "malware_attach") {
			$outh{"malware_attach"} = $n; 
		} elsif ($parm eq "malware_url") {
			$outh{"malware_url"} = $n; 
	
		}
 
	}
}
 
sub query_mails {
	$stmt = $db->prepare("select count(*) from mails;");
	($mail_count) = $db->selectrow_array($stmt);
}
 
sub query_quarantine {
	$stmt = $db->prepare("select count(*) from quamail;");
	($qua_count) = $db->selectrow_array($stmt);
}
 
# XXX execution start
%outh = ();
&getstats;
&query_mails;
&query_quarantine;
$outh{"Mails"} = $mail_count;
$outh{"Quarantined"} = $qua_count;
 
syslog("info", $json->canonical->pretty->encode(\%outh));
print($json->canonical->pretty->encode(\%outh));
$db->disconnect;

