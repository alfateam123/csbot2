package csbot2::barebones;
use strict;
use warnings;
use feature "say";

sub init
{
    say "[~] barebones module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :command (.+?)$/i)
    {
        say $irc "PRIVMSG $channel :output.";
    }
}    
1;
