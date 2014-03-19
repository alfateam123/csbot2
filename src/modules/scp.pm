package csbot2::scp;
use strict;
use warnings;
use LWP::UserAgent;
use HTML::Entities;
use feature "say";

sub init
{
    say "[~] scp module init";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*scp-(\d+).*$/i)
    {
        my $scp = $2;
        my $url = "";
        if ($scp < 1000)
        {
            $url = "http://www.scp-wiki.net/scp-series";
        }
        else
        {
            if ($scp < 2000)
            {
                $url = "http://www.scp-wiki.net/scp-series-2";
            }
            else
            {
                $url = "http://www.scp-wiki.net/scp-series-3";
            }
        }

        my $response = LWP::UserAgent -> new -> get($url) -> decoded_content;
        my @responze = split /\n/, $response;

        foreach (@responze)
        {
            say $irc "PRIVMSG $channel :SCP-$scp", decode_entities($1), " http://www.scp-wiki.net/scp-$scp" if /<li><a href="\/scp-$scp">SCP-$scp<\/a>( - .*)<\/li>/i;
        }
    }
}
1;
