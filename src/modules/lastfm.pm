package csbot2::lastfm;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :lastfm stats (.+?)$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getinfo&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $2) -> decoded_content;
        my $dati = decode_json $json;

        if ($dati -> {"message"} eq "No user with that name was found")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
            return;
        }
        else
        {
            my $name = $dati -> {"user"} -> {"name"};
            my $playcount = $dati -> {"user"} -> {"playcount"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getbannedtracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $bannedtracks = $dati -> {"bannedtracks"} -> {"\@attr"} -> {"total"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getlovedtracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $lovedtracks = $dati -> {"lovedtracks"} -> {"\@attr"} -> {"total"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $toptrackname = $dati -> {"toptracks"} -> {"track"}[0] -> {"name"};
            my $toptrackcount = $dati -> {"toptracks"} -> {"track"}[0] -> {"playcount"};
            my $toptrackartist = $dati -> {"toptracks"} -> {"track"}[0] -> {"artist"} -> {"name"};

            say $irc "PRIVMSG $channel :" . $name . " has listened to \x02" . $playcount . "\x02 songs. He banned \x02" . $bannedtracks . "\x02 tracks and loved \x02" . $lovedtracks . "\x02.";
            say $irc "PRIVMSG $channel :His top track is \x02" . $toptrackname . "\x02 by " . $toptrackartist . ". He listened to it " . $toptrackcount . " times.";
        }
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?lastfm stats?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getinfo&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $config -> {"lastfmaliases"} -> {$1}) -> decoded_content;
        my $dati = decode_json $json;

        if ($dati -> {"message"} eq "No user with that name was found")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
            return;
        }
        else
        {
            my $name = $dati -> {"user"} -> {"name"};
            my $playcount = $dati -> {"user"} -> {"playcount"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getbannedtracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $bannedtracks = $dati -> {"bannedtracks"} -> {"\@attr"} -> {"total"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getlovedtracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $lovedtracks = $dati -> {"lovedtracks"} -> {"\@attr"} -> {"total"};

            $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.gettoptracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $name) -> decoded_content;
            $dati = decode_json $json;
            my $toptrackname = $dati -> {"toptracks"} -> {"track"}[0] -> {"name"};
            my $toptrackcount = $dati -> {"toptracks"} -> {"track"}[0] -> {"playcount"};
            my $toptrackartist = $dati -> {"toptracks"} -> {"track"}[0] -> {"artist"} -> {"name"};

            say $irc "PRIVMSG $channel :" . $name . " has listened to \x02" . $playcount . "\x02 songs. He banned \x02" . $bannedtracks . "\x02 tracks and loved \x02" . $lovedtracks . "\x02.";
            say $irc "PRIVMSG $channel :His top track is \x02" . $toptrackname . "\x02 by " . $toptrackartist . ". He listened to it " . $toptrackcount . " times.";
        }
        return;
    }

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
            say $irc "PRIVMSG $channel :", $dati -> {"recenttracks"} -> {"\@attr"} -> {"user"} , " last listened to \x02", $dati -> {"recenttracks"} -> {"track"}[0] -> {"name"}, "\x02 by ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"artist"} -> {"#text"}, " in ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"album"} -> {"#text"}, ".";
        }
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?lastfm ?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://ws.audioscrobbler.com/2.0/?method=user.getrecenttracks&api_key=" . $config -> {"apikeys"} -> {"lastfm"} . "&format=json&user=" . $config -> {"lastfmaliases"} -> {$1}) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"message"} eq "No user with that name was found")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            say $irc "PRIVMSG $channel :", $dati -> {"recenttracks"} -> {"\@attr"} -> {"user"} , " last listened to \x02", $dati -> {"recenttracks"} -> {"track"}[0] -> {"name"}, "\x02 by ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"artist"} -> {"#text"}, " in ", $dati -> {"recenttracks"} -> {"track"}[0] -> {"album"} -> {"#text"}, ".";
        }
    }
}    
1;
