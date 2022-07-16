# Why Perl is still relevant in 2022

While Perl might seem like an outdated scripting language, it still has plenty
of relevant uses today.

If you love UNIX/Linux/BSD like me, then you have definitely learnt Perl
and programmed in it. I am pretty certain you have also used Perl more
than once, perhaps several times. The language was created in 1987 as a
general purpose UNIX scripting language, but has undergone many changes
since then (even spawning another programming language, 
[Raku](https://raku.org)). 

You may have used it for occasional sys admin tasks, in your tool chain,
or to enhance some shell scripts that needed more gas. But Perl is more
than just scripting. 

From the amount of talk about Perl on Reddit or Stack Overflow, you
might think it’s dead. It’s far from dead, and is still very relevant to
software engineering today. 

## What makes it special?

Perl is a high-level language. It is weakly typed , has synchronous
flow, and is an interpreted language. It has garbage collection and
excellent memory management. Perl 5 is open source and free to
contribute to. 

Perl’s primary strength is in text processing. Be it a regex-based
approach or otherwise, Perl is excellent for logfile analysis, text
manipulation, in-place editing of files, and scouring structured text
files for specific field values.

Perl is very UNIX-friendly. Perl serves as a wrapper around UNIX tools and is
fully integrated into OS semantics. Other languages don’t attempt this. As a
result, it excels at pipes, file slurping, inter-process communication and other
geeky tasks. Like C, it can create UNIX daemons or server processes that run in
the background. We can easily invoke a Perl daemon to avoid spending hours
working on C and avoid several [security
flaws](https://portswigger.net/daily-swig/c-is-least-secure-programming-language-study-claims#:~:text=The%20top%20vulnerabilities%20found%20in,programming%20language%20in%20the%20list.).

Like [npm](https://www.npmjs.com/) for node.js, Perl has a vibrant 
development community in [CPAN](https://metacpan.org/), with a vast 
archive of Perl modules. You can find a module to do anything you want. 
Most modules are written in pure Perl without resorting to C, though 
some performance intensive modules have an XS component that uses C 
for performance.

Through CPAN, you can wrap many databases—SQLite, MySQL, Postgres, and
more—in Perl code using database driver (DBD) modules. These export the
DB operations using Perl’s own semantics into unified portable Perl code
that hides the complexities of the database. 

Perl supports arrays, hashes, and references using which you can code in
very powerful ways without thinking deeply about data structures or
algorithms. Most CPAN modules give you both a functional style as well
as the object oriented one. By giving you that choice, you can pretty
much do your task your own way.

## What sort of problems make Perl a natural?

As stated above, Perl does very well with text processing. It can scour CSV
files for data fields based on complex regex statements. It is a tool of choice
for parsing log files. It can quickly edit settings files. Perl is also a natural
for various format conversions, generating PDFs, HTML, or XML.

In early days of the internet, Perl served as the foundation of a lot of
basic networking tasks: common gateway interface (CGI), MIME decoding in
emails, even opening websockets between a client and server. It still
excels here, and can handle networking tasks without running a whole
server application.

For power UNIX users, Perl lets you automate nearly any action that you
like. You can create daemons—small, constantly running programs—that
will automatically take actions when their conditions are met. 

Testing is at the core of Perl culture, that provide excellent [test toolkits
and
infrastructures](http://www.modernperlbooks.com/mt/2009/04/a-test-infected-culture.html).
Any module uploaded to the CPAN will pass automatically through the *[CPAN
Testers Reports](http://www.cpantesters.org/page/about.html), a multi-platorm
testing ground that operate since 1998. Standard Perl tests can also be run in [
build
pipelines](https://stackoverflow.com/questions/533553/perl-build-unit-testing-code-coverage-a-complete-working-example).

## A simpler way to code, with flexibility when needed

In today’s event-loop-centric asynchronous world of JavaScript, node.js,
and TypeScript, Perl offers a very straight-forward code flow, simplicity 
and control.

The fact that code flows synchronously makes a big difference in
debugging and getting started writing working code. Perl has supported
threads for long time, but I have never used them. 

In case you need the asynchronous paradigm, depsite it is not allowed at the Perl's 
core, it is possible to implement it with modules. An robust example is  
[`Future::AsyncAwait`](https://metacpan.org/pod/Future::AsyncAwait)) that 
*provides syntax for deferring and resuming subroutines* with the `async` 
and `await keywords`. An alternative can be 
[`Mojo::Promise`](https://metacpan.org/pod/Mojo::Promise), a _Perl-ish 
implementation of [Promises/A+](https://promisesaplus.com/) and a superset 
of [ES6 Promises](https://duckduckgo.com/?q=\mdn%20Promise)_.  

Perl includes a number of specialized operators that process data in
unique ways. You can use the diamond `<>` operator to eat up any stream,
file, socket, pipe, named pipe, whatever.

The regex operator `=~` means regular expressions can be included in
functions very easily. 

Perl emphasizes the *get what you want the way you want* philosophy, 
also known as [TMTOWTDI](https://en.wikipedia.org/wiki/There%27s_more_than_one_way_to_do_it).

Let us examine some code samples to get some perspective by creating a sha256 digest of a string.

This is how you do in node.js:

```javascript
const {
  createHash
} = require('node:crypto');

const hash = createHash('sha256');
data = 'Stack Overflow is cool';
hash.update(data);
console.log(hash.copy().digest('hex'));
```

In Perl let's examine two ways (more could be possible). One is the functional 
approach:

```perl
use Digest::SHA qw(sha256_hex);

my $data = 'Stack Overflow is cool';
my $hexdigest = sha256_hex($data);
print("Functional interface :: " . $hexdigest . "\n");
```

Another is the object-oriented approach:

```perl
use Digest::SHA

my $sha = Digest::SHA->new('sha256');
$sha->add($data);               # feed data into stream
my $hexdigest = $sha->hexdigest;
print("OO interface ::" . $hexdigest);
```

Here’s how you do it in Python:

```python
import hashlib
m = hashlib.sha256()
m.update(b"Stack Overflow is cool")
print(m.hexdigest())
```

## Garbage collection

For a language *sometimes* considered only good for scripting, it has garbage
collection. It’s a simple form called [reference
counting](https://perldotcom.perl.org/article/the-trouble-with-reference-counting/),
where Perl counts the number of references to a variable and reclaims those
variables if there are no more references (or if a program leaves the scope that
a variable was created in). The language itself manage the memory: the
programmer don't need to take care of it as with the C language `free()` and
`malloc()` functions.

## Debugging

You can always use the `die()` diagnostic tool, the core `Data::Dumper` to 
dump your data structures, or [`Data::Printer`](https://metacpan.org/pod/Data::Printer)
to inspect complex objects.

All those allow to figure out causes in case something does not go as 
planned. Perl can also be run in debug mode with the `-d` switch.

## Comparing Perl to other languages

Now let us compare Perl to other languages once again. What about non
blocking socket I/O or file read? What about dealing with big data? What
about binary data?

In all these departments Perl has its muscles to flex. For binary data
however, you are much better off with C or something. Perl does have
`ord`, `pack`, and friends. But for text based protocols like SMTP, HTTP,
and the like, Perl socket I/O is quite nice. Particularly using the
diamond operator, `<>`, for consuming data from any file descriptor.

What do these things remind you of…that’s right, UNIX. Perl is living
example of how going all the way with UNIX philosophy gets things done.

People talk of node.js streams and so on, but to me it looks like a joke
compared to the UNIX and Perl world.

Perl is however an easy alternative to insecure PHP. But for some reason
the world does not want to give up on PHP. Perl requires more knowledge
and has a steep learning curve compared to PHP, but Perl is Perl. You
use it anywhere you want and get things done.

### Perl vs Python

Python has an interactive shell where you can easily develop code and
learn. It is amazing and really helps language learners. Python serves
as an excellent learner’s programming language.

Perl however has a `-c` switch to just compile the code to check for basic
syntax errors.

Perl has use strict and `-w` flags which make it more resistant to
unintended variable spelling errors and scoping problems. Python does
not offer that.

Python is an out and out object-oriented paradigm. Perl is a mix. Python
offers several functional programming concepts like lambda, map, and
friends, but it remains rooted in [OOP](https://stackoverflow.blog/2020/09/02/if-everyone-hates-it-why-is-oop-still-so-widely-spread/).

Perl is more invested in using traditional references and hash semantics
for subroutines and other advanced usage. Python tries to do it using
objects a little like how node.js does it.

Python has Jupyter notebook that takes the power of Python to the
browser. Python scripts tend to be shorter than Perl in general. Python
has more economic syntax, excellent saving in lines of code by chaining
objects, but Perl shines in other areas.

Sometimes it is not an apples to apples comparison as each programming
language has its own benefits and specific uses.

### Perl vs node.js

Node.js is fully object-oriented, but functions are first class
variables, which means you can use a function name any which way you
want and invoke it in creative ways, but this risks confusing beginners.
It is fully asynchronous.

The node.js program flow can be scary for beginners. Even experienced
programmers struggle with code flow and figuring out when a function
returns. It can lead to callback hell, though promises and async/await
make things better—if they are used. But the event loop and single
threaded node.js flow makes it harder to use for one off tasks.

Perl is pleasant and more straight-forward. Typically, if you wish to
use a third-party library to solve a particular problem, you can either
do it using node.js or Perl. The open source modules for plugging into
most third-party libraries exist for both languages.

Most of the time, node.js relies on package.json and local
installations. Perl depends on system-wide installations of dependencies
or libraries/modules.

### Perl vs ksh/bash

Well, this is a funny thing to write. Perl could be a contender for
shell-scripting jobs as it is a scripting language, correct? But Perl
installation is a factor to consider whether to use it or some shell in
a resource-constrained environment like Raspberry Pi or something.

Perl does offer a lot of really nice things lacking in shell scripts,
but this really bears no further discussion. It is not a meaningful
comparison. For instance, we don’t compare ksh and Python but tend to
talk about Perl in same context. This is due to its roots. Otherwise,
there is no meaning in this.

## Beyond the drawbacks of Perl

While I am a strong supporter of Perl, let us be balanced and examine
why it is not making inroads in certain areas like AI. In today’s AI and
ML centric world, Python seems to have made a very strong footprint.

When it comes to the performance of node.js and its event loop single-threaded
performance, Perl could seem to not be a contender, but modules allow to
extend it's possiblitities.

Because it continued to evolve by taking it's inspiration from other languages,
it can provide production ready implementations for event loops, promises,
object oriented programming. In the last few years, the
[Corinna](https://github.com/Ovid/Cor) specifications and
[Object::Pad](https://metacpan.org/pod/Object::Pad) implementation are preparing
the introduction of modern OOP in the Perl core.

It is continously improved by a large community and each release provide new
features that takes it to the next step. Notable examples being:

- v5.34 provides an experimental [`try / catch`
  syntax](https://perldoc.perl.org/5.34.0/perlsyn#Try-Catch-Exception-Handling)
  and the [`perlgov` documentation](https://perldoc.perl.org/5.34.0/perlgov),
  exposing goals, scope, system, and rules for Perl's new governance model,
- v5.36 provide non-experimental [subroutines
  signatures](https://perldoc.perl.org/5.36.0/perldelta#Core-Enhancements)

## Why it is still relevant in 2022

Perl is not going away. That ain’t gonna happen.

It is used in production codebases of many
companies, for tasks as diverse as web development, databases access, log
analysis or web crawling. It is a core component of most unix-like systems.

Many legacy production systems rely on Perl and new Perl applications are
flourishing using the modern Perl toolkits available through CPAN. 

If CGI was an important historic part of the Perl culture until the mid 2000, it
was [removed from Perl core with 5.22 in
2014](http://www.modernperlbooks.com/mt/2013/05/ejecting-cgipm-from-the-perl-core.html).
Since a long time, CGI is not the recommended way to handle web development [in
favor of the alternatives](https://metacpan.org/pod/CGI::Alternatives) provided
by he community. Two notables web frameworks being [Dancer](https://dancer.pm)
and [Mojolicious](https://mojolicious.org).

In terms of bindings to other libraries and utilities, Perl is as good as other
choices. For instance, if you wish to talk to
[libcurl](https://metacpan.org/pod/WWW::Curl) or
[libtls](https://github.com/rsimoes/Net-GnuTLS) or some third-party open-source
library or database, then we can often choose the language we like. Here, Perl
is supported out of the box and you can easily get your job done.

Perl shines in what it is good at. And as long as the problems it solves
well are not solved by other tools, Perl will continue to exist and
grow.

## Conclusion

Perl has always been very remarkable about its documentation and
tutorials — perhaps being too wordy at times — but clearly they are
developer-friendly.

Hopefully this article makes a case for Perl that is convincing and
reasonably objective based on current trends, usage statistics, and
developer base. A programmer is typically influenced by factors that
differ from that of a business need or a manager. In both cases, Perl
makes a case as it offers convenience, quick development times, and rich
community support and tooling.


