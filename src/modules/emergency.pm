package csbot2::emergency;
use strict;
use warnings;
use feature "say";

sub init
{
    say "[~] emergency module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :emergency (.+?)$/i)
    {
        say $irc "PRIVMSG $channel :$2: https://www.youtube.com/watch?v=8Q7FFjUpVLg";
    }
}    
1;
