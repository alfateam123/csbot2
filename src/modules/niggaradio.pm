package csbot2::niggaradio;
use strict;
use warnings;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*\bniggaradio\b.*$/i)
    {
        my $xml = LWP::UserAgent -> new -> get("http://niggazwithattitu.de:9000/status2.xsl");
        if ($xml -> is_success)
        {
            my $res = $xml -> decoded_content;
            my $song = $1 if $res =~ /<fullname>(.*)<\/fullname>/i;
            my $listeners = $1 if $res =~ /<listeners>(.*)<\/listeners>/i;
            say $irc "PRIVMSG $channel :Niggaradio is currently playing $song with $listeners internetfags listening.";
        }
        else
        {
            say $irc "PRIVMSG $channel :Wut? something wrong happened here.";
        }
    }
}    
1;
