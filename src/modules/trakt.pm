package csbot2::trakt;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt (.+?)$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $config -> {"apikeys"} -> {"trakt"} . "/" . $2) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"status"} eq "failure")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            my $tktnick = $dati -> {"username"};

            if (defined $dati -> {watching} -> {show} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching}-> {show} -> {title}, " S", $dati -> {watching} -> {episode} -> {season}, "E", $dati -> {watching}-> {episode} -> {number}, ".";
                return;
            }
            if (defined $dati -> {watching}-> {movie} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching} -> {movie} -> {title};
                return;
            }            
            if (defined $dati -> {watched}[0] -> {show} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched ", $dati -> {watched}[0] -> {show} -> {title}, " S", $dati -> {watched}[0] -> {episode} -> {season}, "E", $dati -> {watched}[0] -> {episode} -> {number}, ".";
            }
            if (defined $dati -> {watched}[0] -> {movie} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched ", $dati -> {watched}[0] -> {movie} -> {title};
            }
        }
    }
}    
1;
