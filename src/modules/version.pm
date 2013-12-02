package csbot2::version;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*${nick}.*version.*$/i)
    {
            say $irc "PRIVMSG $channel :", $config -> {"config"} -> {"version"};
    }
}    
1;
