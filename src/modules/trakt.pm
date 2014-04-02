package csbot2::trakt;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use DateTime;
use feature "say";

sub init
{
    say "[~] trakt module init";
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt stats (\S+)\s?.*$/i)
    {
        trakt_stats($2, $config -> {"apikeys"} -> {"trakt"}, $irc, $channel);
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?trakt stats ?.*$/i)
    {
        trakt_stats($config -> {"traktaliases"} -> {$1}, $config -> {"apikeys"} -> {"trakt"}, $irc, $channel);
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt (\S+)\s?.*$/i)
    {
        trakt($2, $config -> {"apikeys"} -> {"trakt"}, $irc, $channel);
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?trakt ?.*$/i)
    {
        trakt($config -> {"traktaliases"} -> {$1}, $config -> {"apikeys"} -> {"trakt"}, $irc, $channel);
        return;
    }
}

sub trakt_stats
{
    my ($user, $apikey, $irc, $channel) = @_;
    my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $apikey . "/" . $user) -> decoded_content;
    my $dati = decode_json $json;
    if ($dati -> {"status"} eq "failure" && not (defined($dati -> {"username"}) && defined($dati -> {"stats"} -> {"shows"} -> {"collection"}) && defined($dati -> {"stats"} -> {"episodes"} -> {"collection"}) && defined($dati -> {"stats"} -> {"movies"} -> {"collection"}) && defined($dati -> {"stats"} -> {"episodes"} -> {"watched_unique"}) && defined($dati -> {"stats"} -> {"movies"} -> {"watched_unique"})))
    {
        say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
    }
    else
    {
        say $irc "PRIVMSG $channel :" . $dati -> {"username"} . " collected \x02" . $dati -> {"stats"} -> {"shows"} -> {"collection"} . "\x02 shows (\x02" . $dati -> {"stats"} -> {"episodes"} -> {"collection"} . "\x02 episodes) and \x02" . $dati -> {"stats"} -> {"movies"} -> {"collection"} . "\x02 movies.";
        say $irc "PRIVMSG $channel :He watched \x02" . $dati -> {"stats"} -> {"episodes"} -> {"watched_unique"} . "\x02 of those episodes and \x02" . $dati -> {"stats"} -> {"movies"} -> {"watched_unique"} . "\x02 movies.";
    }
    return;
}

sub trakt
{
    my ($user, $apikey, $irc, $channel) = @_;
    my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $apikey . "/" . $user) -> decoded_content;
        my $dati = decode_json $json;
        if (defined $dati -> {status} && $dati -> {"status"} eq "failure")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            my $tktnick = $dati -> {"username"};

            if (defined $dati -> {watching} && (ref $dati -> {watching} eq ref {}))
            {
                if (defined $dati -> {watching} -> {show} -> {title})
                {
                    say $irc "PRIVMSG $channel :$tktnick is watching \x02", $dati -> {watching}-> {show} -> {title}, " S", sprintf("%02d", $dati -> {watching} -> {episode} -> {season}), "E", sprintf("%02d", $dati -> {watching} -> {episode} -> {number}), "\x02.";
                    return;
                }
                if (defined $dati -> {watching}-> {movie} -> {title})
                {
                    say $irc "PRIVMSG $channel :$tktnick is watching \x02", $dati -> {watching} -> {movie} -> {title}, "\x02.";
                    return;
                }
            }            
            elsif (defined $dati -> {watched}[0] -> {show} -> {title})
            {
                my $date = DateTime -> from_epoch(epoch => $dati -> {watched}[0] -> {watched});
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {show} -> {title}, " S", sprintf("%02d", $dati -> {watched}[0] -> {episode} -> {season}), "E", sprintf("%02d", $dati -> {watched}[0] -> {episode} -> {number}), "\x02 on ", $date -> day_abbr, " ", $date -> month_abbr, " ", $date -> day, " ", $date -> year,".";
            }
            elsif (defined $dati -> {watched}[0] -> {movie} -> {title})
            {
                my $date = DateTime -> from_epoch(epoch => $dati -> {watched}[0] -> {watched});
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {movie} -> {title} . "\x02 on ", $date -> day_abbr, " ", $date -> month_abbr, " ", $date -> day, " ", $date -> year,".";
            }
            else
            {
                say $irc "PRIVMSG $channel :uhm. it seems that $tktnick didn't watch a TV show or a movie lately. Use the \"Check-in\" functionality to scrobble movies and episodes while you're watching them!";
            }
        }
}

1;
