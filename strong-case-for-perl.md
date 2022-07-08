# Why perl is still hugely relevant for solving world’s computing problems

If you love UNIX/Linux/BSD and are like me, then you have definitely
learnt perl, programmed in it. I am pretty certain you have also used
perl more than once, perhaps several times.

You would have used it for occasional sys admin tasks, you could have
used it in your tool chain, or you use it for enhancing some shell
scripts you have but need more gas.

In any case, perl is not just limited to such corner cases. It is rich,
a complete solution to address several deep problems in computing.

## What is perl?                                                               
In this article we will explore how perl is still relevant. There is so
little talk of perl on Reddit or Stackoverflow, it almost looks like it
is dead.

But it is not and will not die either. This article explores the reasons
why.

Perl is not meant for solving problems in a vacuum like most other
programming languages without caring for OS level semantics.

Perl is very UNIX friendly. Pipes, file slurping, inter process
communication and other geeky tasks are done really well with perl.

It can also do what C does in UNIX like creating daemons or server
processes that run in the background. We can easily invoke a perl daemon
to avoid spending hours working on C and get rid of several security
flaws thereby.

## What makes it special?                                                      
Perl is famous for text processing. Be it the regex based approach or
otherwise, perl is excellent for logfile analysis, manipulation, in
place editing of files and scouring text for fields.

It has several database wrappers using the DBD family of modules in
CPAN. Several CPAN modules exist that export the DB operations using
perl's own semantics thereby getting a unified portable perl code that
hides the database behind. You could use the same semantics for SQLite,
MySQL, Postgres or any such using the DBD wrapping.

Perl supports arrays, hashes and references using which you can code in
very powerful ways without thinking deeply about data structures or
algorithms. Most CPAN modules give you both a functional style as well
as the object oriented one. By giving you that choice, you can pretty
much do your task your own way.

## What sort of problems make perl a natural?                                  
Perl serves as a sounding board for ideas. You can always find a very
vast array of options if you are focused on backend, UNIX systems,
having to deal with config or log files.

But perl is also a natural for various format conversions, generating
PDFs, HTML or XML.

It is almost as if Perl is a lost cousin from the UNIX family.

## Other discussions about CPAN , developer community and man pages            
CPAN is one of the most vibrant perl module/library development
communities. You can find a module to do anything you want. Most modules
are written in pure perl without resorting to C.

Some performance intensive modules have an XS component that use C for
performance.

In this article we shall examine several code samples for illustrating
how powerful perl can be for enriching a programmer's life.

## The perl world and how it is used for tasks like MIME decoding, the         mechanize toolkit,DB wrappers and so on                                       
In today's event loop centric asynchronous world of javascript, node.js
and typescript, Perl offers a very straight forward code flow and
simplicity and control.

The learning curve could be moderate to high depending on how proficient
you wish to get with Perl, but the fact that code flows synchronously
makes a big difference in debugging and getting things going.

Let us examine some code samples to get some perspective.

Let us say we have to create a `sha256 digest` of a string.

This is how you do in node.js.

```javascript
const {
  createHash
} = require('node:crypto');

const hash = createHash('sha256');
data = 'stackoverflow is cool';
hash.update(data);
console.log(hash.copy().digest('hex'));

```

And in perl there are two ways.

One is functional approach.

```perl


use Digest::SHA qw(sha256_hex);

$data = 'stackoverflow is cool';
$hexdigest = sha256_hex($data);
print("Functional interface :: " . $hexdigest . "\n");
```

Another is object oriented approach.

```perl
$sha = Digest::SHA->new('sha256');
$sha->add($data);               # feed data into stream
$hexdigest = $sha->hexdigest;
print("OO interface ::" . $hexdigest);
```

In python this is how you do it.

```python
import hashlib
m = hashlib.sha256()
m.update(b"stackoverflow is cool")
print(m.hexdigest())
```

This is a rather trivial example. But you get the point.

But in case of Perl, I did one thing in UNIX without resorting to
Google.

`$apropos sha256` and that showed me the man page for perl module for
hashing.

Didn't I say perl has the best man pages of all the languages? You must
check out some interesting ones. perlipc, perllol and perlreftut.

In typical UNIX style, perl has phenomenal literature in form of man
pages in traditional UNIX style. Exactly like how OpenBSD has a man page
for every damn thing,even config files.

In case, perl lacks a man page , then the thing to do is 

`perldoc -f <func>`

You can get the sections for functions like grep, strip, substr, splice
and friends.

In terms of array functions and substring manipulations perl lags behind
Python. You can't say perl has any major plus there. Python is too good.
But perl is very good at things that make perl great , stuff like
Tie::File, File::Slurp and friends.

Python does not have a CPAN like thing. It has what is called as PEP or
something, anaconda and friends. It even has a virtualenv.

But the deep love that Perl shares for UNIX style semantics is not
shared by any other programming language.

No wonder why UNIX guys love Perl so much. In OpenBSD, the package
management is entirely written in Perl. And it has many scripts for
upgrade, system admin maintenance in perl too, like syspatch, sysupgrade
and friends.

## More food for thought

Ok this is just a very simple case of some crypto mathematics. How about
a file download using HTTP(S)? Now let us compare the 3 languages once
again. What about non blocking socket I/O or file read?

What about dealing with big data? What about binary data?

In all these departments perl has its muscles to flex. For binary data
however,you are much better off with C or something. Perl does have ord,
pack and friends. But for text based protocols like SMTP, HTTP and the
like, perl socket I/O is quite nice. Particularly using the diamond
operator, <> for consuming data from any file descriptor.

These things remind you of..yes you got right, UNIX. Perl is living
example of how going all the way with UNIX philosophy gets shit done.

People talk of node.js streams and so on, but to me it looks like a joke
compared to UNIX and perl world. 

Usually Java programs lend easy porting to Python. There is a youtube
download API(used by `youtube-dl` and `yt-dlp`. And Python being object
oriented from ground up is good with even libreoffice plugins and such.

Perl is however an easy alternative to insecure PHP. But for some reason
the world does not seem to be giving up on PHP. Perl requires more
knowledge, has steep learning curve as compared to PHP, but perl is
perl. You use it anywhere you want and get shit done.

## MIME decoding example

Here is what I wrote long ago for my needs. It displays an email by
doing recursive decoding of MIME bodies.

```

#!/usr/bin/perl 

use JSON;
use CGI;
use DBI;
use Sys::Syslog;
use Broker;
use Encode qw/decode/;
use File::Basename;
use MIME::Parser;
use File::Copy;
use File::Glob;
use File::Path;

$q = CGI->new;
print $q->header('application/json');
$json = JSON->new;
@mailBody =();
@mailText =();

openlog("--Show one quamail...  :");

my $db = DBI->connect("dbi:Pg:host=/tmp", "postgres", undef, {AutoCommit => 0});

if(!defined($db)) {
	print("error","Could not connect to Postgres db");
}

sub dump_entity {
	my ($entity, $name) = @_;
	defined($name) or $name = "'anonymous'";
	my $IO;

# Output the body:
	my @parts = $entity->parts;
	if (@parts) {                     # multipart...
		my $i;
		foreach $i (0 .. $#parts) {       # dump each part...
			dump_entity($parts[$i], ("$name, part ".(1+$i)));
		}
	}
	else {                            # single part...	

# Get MIME type, and display accordingly...
		my $type = $entity->head->mime_type;
		my $body = $entity->bodyhandle;
		if ($type =~ /text\/html/) {     
			if ($IO = $body->open("r")) {
				while (defined($_ = $IO->getline)) {
					push @mailText, $_; 
				}
				$IO->close;
			}
			else {       # d'oh!
				print "$0: couldn't find/open '$name': $!";
			}
		} elsif ($type =~ /text\/plain/) {   
			push @mailText, "<pre>";
			if ($IO = $body->open("r")) {
				while (defined($_ = $IO->getline)) {
					push @mailText, $_; 
				}
				push @mailText, "</pre>"; 
				$IO->close;
			}
			else {       # d'oh!
				print "$0: couldn't find/open '$name': $!";
			}

		} else {                                 # binary: just summarize it...
			my $path = $body->path;
			my $size = ($path ? (-s $path) : '???');

			$f = basename($path);

			push @mailBody, "<p>Attached <a href=\"/$path\">$f<a> Size:: $size bytes </p>";
		}
	}
	1;
}

$id = $q->param('id');

$stmt = "select envip,mailfile,headers,subject,size,fromid,toid,date from quamail where id = $id";

@row = $db->selectrow_array($stmt);
($envip,$mailfile, $headers, $sub, $size, $from , $to, $date) = @row;

push @mailBody, "<strong>From</strong>: $from<br/>";
push @mailBody, "<strong>To</strong>: $to<br/>";
push @mailBody, "<strong>Date</strong>: $date<br/>";
push @mailBody, "<strong>Subject</strong>: $sub<br/>";

push @mailBody, "<br/>";

$mfile = "/quamail/$mailfile";
$parser = MIME::Parser->new;
$parser->output_under("/tmp");
$entity = $parser->parse_open($mfile);

push @mailBody, "<br/>";
&dump_entity($entity);
push @mailBody, "<br/>";
push @mailBody, @mailText;

$h = {'mailBody' => [@mailBody]};
print($json->pretty->encode($h));
@delfiles=</tmp/msg*>;
$ign = rmtree(@delfiles, {verbose => 0});

```

I don't want to give similar examples in other languages. Most things
can be done equally well in other languages as long as they are similar,
which is not typed, high level scripting language etc.

Now I find lua very interesting. You have tables in places of perl hash
tables or associative arrays. And everything in lua is a table.

In case of perl, you can argue everything is a reference or pointer in
C.

But how perl goes about achieving such well supported documentation, the
CPAN install system which downloads modules either using command

`perl -MCPAN 'install <mod>' `

or

`cpanm --interactive <mod>`

And the use of perl to automate mundane tasks so beautifully is what
makes me warm and fuzzy inside.

Python sure has more economic syntax, excellent saving in LOC by
chaining objects just like in javascript but perl shines in other areas.

Sometimes it is not an apples to apples comparison as each programming
language has something of the author's mind and the community that grows
around it influencing decisions.

## Event loops, threading and multi tasking

Perl has supported threads for long time, but I never used it one single
time. Nowadays nobody talks about threads anyway.

Perl is best run single task. And if you wanted performance today you
have javascript and you had C. With added complexity and debugging
nightmares.

Perl is usually emphasizing the get what you want the way you want
philosophy.

Several Linux and BSD systems come with perl pre installed and usually
your job is only to add missing modules from CPAN.

You also find that Linux distributions like Ubuntu have packaged most
popular perl modules as well.

## Using perl in geo IP query

Here is a geoIP query done in perl.

```
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


```
In above sample you find the usage of perl hashes to good effect. It
usually takes some years of getting to know perl to be able to code
effectively in its own idiom, but that is true of other programming
languages as well.

## Perl daemon example

Here is a daemon I use as well.

```

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
	open F, "/etc/spamcheetah.json";
	$conf = <F>;
	close(F);
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
		&resume_relay;
	}

}

&pass_thro;

Proc::Daemon::Init();
die "Already running!" if Proc::PID::File->running();
for(;;) {
	syslog("info", "Running in pass thro' mode");
	syslog("info", "Sleeping 2 minutes");
	sleep(120);
	&refresh_mtaip;
	$res = &check_mta;
}


```

As you can see from above examples I am heavily invested in perl. And if
you can write daemons and background server processes then that is
definitely not scripting or automation.

That is serious stuff.

## Perl CGI

In the world of server side processing, before javascript became so
heavily used on browser frontend, and before advent of HTML5 and browser
itself being so heavy in functionality and features, nobody could use a
website without perl CGI for database queries and backend work. Even to
display server side top or firewall state or something.

But perl and CGI both seem to be less talked about in the web context.
Now servers for HTTP are run in node.js, be it Express, Hapi or Koa.

Still for most web applications, perl continues to shine in CGI. 

Without server side processing nothing moves, even today.

You can get to know better if you ask attackers and exploit kit writers
if they still have to deal with bugs in perl scripts or something else.

## Can you write CGI in other languages?

With all the talk of node.js based web server frameworks and all that,
most background work happens in that language.

However nothing stops you from having an Angular or React or vue
frontend slapping an nginx or apache instance with perl CGI.

Which is what I do. And python also has made inroads into CGI with
Django and Flask.


## A simple sockets application with perl

I think any article by me is incomplete without talking about sockets.
No, not websockets. That is better handled by some javascript framework
as that is web/HTTP stuff.

Perl does really good web automation but cannot run in browser.

I mean normal sockets programming we learnt.

We have this beautifully documented in

`perldoc perlipc`

And here is a sample for you.

A TCP client code plagiarized straight from man page.

```
   #!/usr/bin/perl
        use strict;
        use warnings;
        use Socket;

        my $remote  = shift || "localhost";
        my $port    = shift || 2345;  # random port
        if ($port =~ /\D/) { $port = getservbyname($port, "tcp") }
        die "No port" unless $port;
        my $iaddr   = inet_aton($remote)       || die "no host:
$remote";
        my $paddr   = sockaddr_in($port, $iaddr);

        my $proto   = getprotobyname("tcp");
        socket(my $sock, PF_INET, SOCK_STREAM, $proto)  || die "socket:
$!";
        connect($sock, $paddr)              || die "connect: $!";
        while (my $line = <$sock>) {
            print $line;
        }

        close ($sock)                        || die "close: $!";
        exit(0);

```

And the server to go with it.

```
     #!/usr/bin/perl -T
     use strict;
     use warnings;
     BEGIN { $ENV{PATH} = "/usr/bin:/bin" }
     use Socket;
     use Carp;
     my $EOL = "\015\012";

     sub spawn;  # forward declaration
     sub logmsg { print "$0 $$: @_ at ", scalar localtime(), "\n" }

     my $port  = shift || 2345;
     die "invalid port" unless $port =~ /^ \d+ $/x;

     my $proto = getprotobyname("tcp");

     socket(my $server, PF_INET, SOCK_STREAM, $proto) || die "socket:
$!";
     setsockopt($server, SOL_SOCKET, SO_REUSEADDR, pack("l", 1))
                                                   || die "setsockopt:
$!";
     bind($server, sockaddr_in($port, INADDR_ANY)) || die "bind: $!";
     listen($server, SOMAXCONN)                    || die "listen: $!";

     logmsg "server started on port $port";

     my $waitedpid = 0;

     use POSIX ":sys_wait_h";
     use Errno;

     sub REAPER {
         local $!;   # don't let waitpid() overwrite current error
         while ((my $pid = waitpid(-1, WNOHANG)) > 0 && WIFEXITED($?)) {
             logmsg "reaped $waitedpid" . ($? ? " with exit $?" : "");
         }
         $SIG{CHLD} = \&REAPER;  # loathe SysV
     }

     $SIG{CHLD} = \&REAPER;

     while (1) {
         my $paddr = accept(my $client, $server) || do {
             # try again if accept() returned because got a signal
             next if $!{EINTR};
             die "accept: $!";

         unless (@_ == 0 && $coderef && ref($coderef) eq "CODE") {
             confess "usage: spawn CLIENT CODEREF";
         }

         my $pid;
         unless (defined($pid = fork())) {
             logmsg "cannot fork: $!";
             return;
         }
         elsif ($pid) {
             logmsg "begat $pid";
             return; # I'm the parent
         }
         # else I'm the child -- go spawn

         open(STDIN,  "<&", $client)   || die "can't dup client to
stdin";
         open(STDOUT, ">&", $client)   || die "can't dup client to
stdout";
         ## open(STDERR, ">&", STDOUT) || die "can't dup stdout to
stderr";
         exit($coderef->());
     }

```

As you can perhaps guess the man page has a plethora of code samples for
you to steal and get your job done.

## How to do cool things with various operators?

We saw the diamond <> operator mentioned above.

You can use it to eat up any stream, file, socket, pipe, named pipe
whatever.

Like that there are many other operators. The regex operator =~ comes to
mind.

But from perl the regex idea traveled to many other languages too.

It is not perl's to begin with. It has always been part of UNIX.

And PCRE is only a small improvement over the usual ones supported in
UNIX shell.

You can do regex in C also regex(7).

Once again I use it in my own code.

But we won't have C samples in this article. I don't see any meaning
comparing perl to C.

All programming languages and operating systems are written in C today.

It is great grand father. So let us keep it that way.

## Why it is still relevant in 2022      

Perl is not going away. No. That ain't gonna happen.

It is still being used in CGI scripts, it is used in several sys admin
tasks and perl is still alive and kicking.

Perl shines in what it is good at. And as long as problems it solves
well are not solved by other tools , perl will continue to exist and
grow.

It may not be getting much news but perhaps this article does something
about that?

## Conclusion

Perl has always been very remarkable about its documentation, tutorials
and being too wordy at times but clearly being developer friendly.

`perldoc perl`

and 

`perldoc perldoc`

would go a long way.

Also I grew up thinking world without perl would be too boring. I am
sure we agree. I am unabashedly a perl fanboy.


