#/usr/bin/env perl
use strict;
use warnings;
use diagnostics;
use IO::Socket::INET;
use JSON;
use feature "say";

my @modules = ("autorejoin", "trakt", "lastfm", "specials", "dieroll", "scp", "mtg", "version", "emergency", "isup", "reddit", "niggaradio", "linktitles");
foreach (@modules)
{
    eval "use modules::$_";
    die("Cannot load $_ : $@") if $@;
}
my $jsonconf = "";
open(my $config, "<", "config.json");
foreach (<$config>)
{
    $jsonconf .= $_;
}
close $config;

$config = decode_json $jsonconf;
$|++; # enable autoflushing

my $server = $config -> {"config"} -> {"server"};
my $port = $config -> {"config"} -> {"port"};
my $nick = $config -> {"config"} -> {"nick"};
my $password = $config -> {"config"} -> {"password"};
my $channel = $config -> {"config"} -> {"channel"};
my $masters = ["nicolapcweek94", "robertof"];

my $irc = IO::Socket::INET->new (
    PeerAddr => $server,
    PeerPort => $port,
    Proto => "tcp"
) or die "Couldn't connect to IRC: $!";

my ($nick_s, $user_s, $host) = ("", "", "");

# USER non è nick!!
say $irc "USER ", $nick, " 0 * :CounterStrikeBot strikes again";
say $irc "NICK ", $nick;

while (<$irc>)
{
    print;
    ($nick_s, $user_s, $host) = ($1, $2, $3) if /^:([^\s]+)!~?([^\s]+)@([^\s]+)/;
    say $irc "QUIT :bb madafackas" if $nick_s ~~ $masters and /^[^\s]+ PRIVMSG ${channel} :gtfo.*\b${nick}\b/i;
    say $irc "PONG :", $1 if /^PING :(.+)$/i;
    if (/^:[^\s]+ (?:422|376)/) {
        say $irc "PRIVMSG NickServ :identify ", $password;
        say $irc "JOIN ", $channel;
    }

    #foreach (@modules)
    #{
    #    my $mod = "csbot2::$_";
    #    $mod->parse($_, $irc, $config, $channel, $nick);
    #}
    
    csbot2::autorejoin->parse ($_, $irc, $config, $channel, $nick);
    csbot2::trakt->parse ($_, $irc, $config, $channel, $nick);
    csbot2::lastfm->parse ($_, $irc, $config, $channel, $nick);
    csbot2::dieroll->parse($_, $irc, $config, $channel, $nick);
    csbot2::scp->parse($_, $irc, $config, $channel, $nick);
    csbot2::specials->parse ($_, $irc, $config, $channel, $nick);
    csbot2::mtg->parse ($_, $irc, $config, $channel, $nick);
    csbot2::version->parse ($_, $irc, $config, $channel, $nick);
    csbot2::emergency->parse ($_, $irc, $config, $channel, $nick);
    csbot2::isup->parse ($_, $irc, $config, $channel, $nick);
    csbot2::reddit->parse ($_, $irc, $config, $channel, $nick);
    csbot2::niggaradio->parse ($_, $irc, $config, $channel, $nick);
    csbot2::linktitles->parse ($_, $irc, $config, $channel, $nick);

    ($nick_s, $user_s, $host) = ("", "", "");
}
