package csbot2::mtg;
use strict;
use warnings;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :mtg (.+?)$/i)
    {
        my $cardname = $2;
        $cardname =~ s/\s/\+/g;
        my $html = LWP::UserAgent -> new -> get("http://magiccards.info/query?q=$cardname&v=card&s=cname") -> decoded_content;
        if ($html =~ /<img\ssrc="(http:\/\/magiccards.info\/scans\/\S+?\/\S+?\/\d+.jpg)"\s+alt="(.+?)" width="312" height="445" style="border: 1px solid black;">/i)
        {
            say $irc "PRIVMSG $channel :$2: $1";
        }
        else
        {
            say $irc "PRIVMSG $channel :Card not found.";
        }
    }
}    
1;
