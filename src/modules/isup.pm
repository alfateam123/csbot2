package csbot2::isup;
use strict;
use warnings;
use LWP::UserAgent;
use feature "say";

sub init
{
    say "[~] isup module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :isup (https?:\/\/(www\.)?\S+\.\w{2,6}\S+?)\s?$/i)
    {
        my $res = LWP::UserAgent -> new -> get($2);
        if ($res -> is_success)
        {
            say $irc "PRIVMSG $channel :$2 is UP.";
        }
        else
        {
            say $irc "PRIVMSG $channel :$2 is DOWN. (hint: the url must be absolute. http://www.google.com works, google.com doesn't.)";
        }
    }
}    
1;
