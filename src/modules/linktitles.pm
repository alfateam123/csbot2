package csbot2::linktitles;
use strict;
use warnings;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG #nwa :.*(https?:\/\/(www\.)?\S+\.\w{2,6}\S+?)\s.*$/i)
    {
        my $res = LWP::UserAgent -> new() -> get($2);
        if ($res -> is_success)
        {
            my $html = $res -> decoded_content;
            my $title = $1 if $html =~ /<title>(.*)<\/title>/i;
            say $irc "PRIVMSG $channel :$title";
        }
    }
}    
1;
