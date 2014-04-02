package csbot2::reddit;
use strict;
use warnings;
use feature "say";

sub init
{
    say "[~] reddit module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} .+?\br\/(\w+)\b.*$/i)
    {
        say $irc "PRIVMSG $channel :http://reddit.com/r/$2";
    }
}    
1;
