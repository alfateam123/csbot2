#/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use IO::Socket::INET;
use feature "say";
use modules::autorejoin;
use modules::trakt;
use modules::lastfm;
use modules::specials;

$|++; # enable autoflushing

my $server = "irc.serv.er";
my $port = 6667;
my $nick = "csbot2";
my $password = "1337pr0p4ssw0rd";
my $channel = "#1337";
my $masters = {"master1", "master2"};

my $irc = IO::Socket::INET->new (
    PeerAddr => $server,
    PeerPort => $port,
    Proto => "tcp"
) or die "Couldn't connect to IRC: $!";

my ($nick_s, $user_s, $host) = ("", "", "");

say $irc "USER ", $nick, " 0 * :CounterStrikeBot strikes again";
say $irc "NICK ", $nick;

while (<$irc>)
{
    print;
    ($nick_s, $user_s, $host) = ($1, $2, $3) if /^:([^\s]+)!~?([^\s]+)@([^\s]+)/;
    say $irc "QUIT :bb madafackas" if $nick_s ~~ $masters and /^[^\s]+ PRIVMSG ${channel} :gtfo.*${nick}.*/i;
    say $irc "PRIVMSG ", $channel, " :sup ", $nick_s if /^[^\s]+ PRIVMSG ${channel} :.*${nick}/i;
    say $irc "PONG :", $1 if /^PING :(.+)$/i;
    if (/^:[^\s]+ (?:422|376)/) {
        say $irc "PRIVMSG NickServ :identify ", $password;
        say $irc "JOIN ", $channel;
    }
    csbot2::autorejoin->parse ($_, $irc, $channel, $nick);
    csbot2::trakt->parse ($_, $irc, $channel, $nick);
    csbot2::lastfm->parse ($_, $irc, $channel, $nick);
    csbot2::specials->parse ($_, $irc, $channel, $nick);
    ($nick_s, $user_s, $host) = ("", "", "");
}
