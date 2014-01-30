package csbot2::linktitles;
use strict;
use warnings;
use LWP::UserAgent;
use HTML::Entities;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*(https?:\/\/(www\.)?\S+\.\w{2,6}\S+)\b?.*$/i)
    {
        if ($1 ne $nick)
        {
            my $res = LWP::UserAgent -> new() -> get($2);
            if ($res -> is_success)
            {
                my $html = $res -> decoded_content;
                my $title = $1 if $html =~ /<title>(.*)<\/title>/i;
                say $irc "PRIVMSG $channel :" . decode_entities($title);
            }
        }
    }
}    
1;
