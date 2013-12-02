package csbot2::reddit;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* r\/(.+?)\s*$/i)
    {
        say $irc "PRIVMSG $channel :https://reddit.com/r/$2";
    }
}    
1;
