#!/usr/bin/perl
use Tie::File;
use Sys::Syslog;
use JSON;
use Proc::Daemon;
use Proc::PID::File;
use IO::Socket::INET;


sub refresh_mtaip {
    local $/;
# XXX read spamcheetah config and store vals
    open my $conf_fh, '<', "/etc/spamcheetah.json";
    $conf = <$conf_fh>;
    close($conf_fh);
    $json = JSON->new;
    $dec = $json->decode($conf);
    %schash = %$dec;
    $/ = "\n";
    $mtaip = $schash{'mtaip'};
}

openlog("Activate_mta");


sub resume_relay {
    syslog("info", "MTA is up resuming relay");
    tie @conf, "Tie::File", "/etc/pf.conf";
    for (@conf) {
        chomp();
        next if(/^#/);

        if(/rdr-to 127\.0\.0\.1 port 6300/) {
            last;
        }
        if(/port smtp\s*$/) {
            $_ =~ s/\s+$//;
            $_ .= ' rdr-to 127.0.0.1 port 6300';
        }
    }
    untie @conf;
    system("/sbin/pfctl -f /etc/pf.conf");
    system("/usr/bin/pkill -HUP smtprelay");
    syslog("info", "Nothing to do EXIT");
    exit(0);

}

sub pass_thro {
    tie @conf, "Tie::File", "/etc/pf.conf";
    for (@conf) {
        chomp();
        next if(/^#/);
        if(/rdr-to 127\.0\.0\.1 port 6300/) {
            $_ =~ s/$&//;
        }
    }
    untie @conf;
    system("/sbin/pfctl -f /etc/pf.conf");
    syslog("info", "ACTIVATED pass thro' as MTA $mta is down");
}

sub check_mta {
    my $sock = new IO::Socket::INET (
            PeerAddr => $mtaip,
            PeerPort => '25',
            Proto => 'tcp',
            Timeout => 15
            );
    if($sock) {
        resume_relay();
    }

}

pass_thro();

Proc::Daemon::Init();
die "Already running!" if Proc::PID::File->running();
for(;;) {
    syslog("info", "Running in pass thro' mode");
    syslog("info", "Sleeping 2 minutes");
    sleep(120);
    refresh_mtaip();
    $res = check_mta();
}

