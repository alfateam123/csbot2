package csbot2::pdffer;
use strict;
use warnings;
use LWP::Simple;
use DateTime;
use feature "say";

sub init
{
    say "[~] pdffer module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :url2pdf (.+?)$/i)
    {
	my $api = "http://do.convertapi.com/Web2Pdf?Plugins=true&Timeout=60&ConversionDelay=5&CUrl=" . $2;
	my $filename = DateTime -> now . ".pdf";
	getstore($api, "../public_html/url2pdf/" . $filename);
        say $irc "PRIVMSG $channel :Converted! Download at https://www.niggazwithattitu.de/u/wasp/url2pdf/$filename";
    }
}    
1;
