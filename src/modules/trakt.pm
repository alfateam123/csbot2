package csbot2::trakt;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt (.+?)$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/<yourapikeyhere>/" . $2) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"status"} eq "failure")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            my $tktnick = $dati -> {"username"};
            say $irc "PRIVMSG $channel :$tktnick last watched ", $dati -> {watched}[0] -> {show} -> {title}, " S", $dati -> {watched}[0] -> {episode} -> {season}, "E", $dati -> {watched}[0] -> {episode} -> {number}, ".";
        }
    }
}    
1;
