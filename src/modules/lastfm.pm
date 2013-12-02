package csbot2::lastfm;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :lastfm (.+?)$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $2) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"message"} eq "No user with that name was found")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            say $irc "PRIVMSG $channel :", $dati -> {"recenttracks"} -> {"\@attr"} -> {"user"} , " last listened to ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"name"}, " by ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"artist"} -> {"#text"}, " in ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"album"} -> {"#text"}, ".";
        }
    }
}    
1;
