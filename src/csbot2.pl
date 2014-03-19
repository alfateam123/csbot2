#/usr/bin/env perl
use strict;
use warnings;
#use diagnostics;
use JSON;
use feature "say";

my $jsonconf = "";
open(my $config, "<", "config.json");
foreach (<$config>)
{
    $jsonconf .= $_;
}
close $config;
$config = decode_json $jsonconf;

my $modules = $config -> {"modules"};

foreach (@$modules)
{
    my $fullname = "csbot2::$_";
    eval "use modules::$_";
    die("Cannot load $_ : $@") if $@;
    #say $_;
    $fullname -> init();
}

$|++; # enable autoflushing

my $irc;
my $server = $config -> {"config"} -> {"server"};
my $port = $config -> {"config"} -> {"port"};
my $nick = $config -> {"config"} -> {"nick"};
my $password = $config -> {"config"} -> {"password"};
my $channel = $config -> {"config"} -> {"channel"};
my $masters = $config -> {"config"} -> {"masters"};
my $version = "0.1.4, now with less nsa!";

if ($config -> {"config"} -> {"ssl"} == 1)
{
    eval "use IO::Socket::SSL";
    $irc = IO::Socket::SSL -> new (
    PeerAddr => $server,
    PeerPort => $port,
    Proto => "tcp"
    ) or die "Couldn't connect to IRC: $!";
}
else
{
    eval "use IO::Socket::INET";
    $irc = IO::Socket::INET -> new (
        PeerAddr => $server,
        PeerPort => $port,
        Proto => "tcp"
    ) or die "Couldn't connect to IRC: $!";
}

my ($nick_s, $user_s, $host) = ("", "", "");

# USER non è nick!!
say $irc "USER ", $nick, " 0 * :CounterStrikeBot strikes again";
say $irc "NICK ", $nick;

while (<$irc>)
{
    #print;
    ($nick_s, $user_s, $host) = ($1, $2, $3) if /^:([^\s]+)!~?([^\s]+)@([^\s]+)/;
    
    say $irc "QUIT :bb madafackas" if $nick_s ~~ $masters and /^[^\s]+ PRIVMSG ${channel} :gtfo.*\b${nick}\b/i;
    
    say $irc "PRIVMSG $channel :$version" if /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*\b?${nick} version.*$/i;

    say $irc "PONG :", $1 if /^PING :(.+)$/i;
    
    if (/^:[^\s]+ (?:422|376)/) {
        say $irc "PRIVMSG NickServ :identify ", $password;
        say $irc "JOIN ", $channel;
    }

    foreach my $name (@$modules)
    {
        my $mod = "csbot2::$name";
        $mod -> parse($_, $irc, $config, $channel, $nick);
    }
    
    ($nick_s, $user_s, $host) = ("", "", "");
}
