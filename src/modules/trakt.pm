package csbot2::trakt;
use strict;
use warnings;
use JSON;
use LWP::UserAgent;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt stats (\S+)\s?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $config -> {"apikeys"} -> {"trakt"} . "/" . $2) -> decoded_content;
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

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?trakt stats ?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $config -> {"apikeys"} -> {"trakt"} . "/" . $config -> {"traktaliases"} -> {$1}) -> decoded_content;
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

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :trakt (\S+)\s?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $config -> {"apikeys"} -> {"trakt"} . "/" . $2) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"status"} eq "failure" && not (defined($dati -> {"username"})))
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            my $tktnick = $dati -> {"username"};

            # if (defined $dati -> {watching})
            # {
            #     if (defined $dati -> {watching} -> {show} -> {title})
            #     {
            #         say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching}-> {show} -> {title}, " S", $dati -> {watching} -> {episode} -> {season}, "E", $dati -> {watching}-> {episode} -> {number}, ".";
            #         return;
            #     }
            #     if (defined $dati -> {watching}-> {movie} -> {title})
            #     {
            #         say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching} -> {movie} -> {title};
            #         return;
            #     }
            # }        
            if (defined $dati -> {watched}[0] -> {show} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {show} -> {title}, " S", $dati -> {watched}[0] -> {episode} -> {season}, "E", $dati -> {watched}[0] -> {episode} -> {number}, "\x02.";
            }
            if (defined $dati -> {watched}[0] -> {movie} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {movie} -> {title} . "\x02.";
            }
        }
        return;
    }

    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :.* ?trakt ?.*$/i)
    {
        my $json = LWP::UserAgent -> new -> get("http://api.trakt.tv/user/profile.json/" . $config -> {"apikeys"} -> {"trakt"} . "/" . $config -> {"traktaliases"} -> {$1}) -> decoded_content;
        my $dati = decode_json $json;
        if ($dati -> {"status"} eq "failure")
        {
            say $irc "PRIVMSG $channel :You don't want to end up dead right? So stahp before it's too late.";
        }
        else
        {
            my $tktnick = $dati -> {"username"};

            # if (defined $dati -> {watching})
            # {
            #     if (defined $dati -> {watching} -> {show} -> {title})
            #     {
            #         say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching}-> {show} -> {title}, " S", $dati -> {watching} -> {episode} -> {season}, "E", $dati -> {watching}-> {episode} -> {number}, ".";
            #         return;
            #     }
            #     if (defined $dati -> {watching}-> {movie} -> {title})
            #     {
            #         say $irc "PRIVMSG $channel :$tktnick is watching ", $dati -> {watching} -> {movie} -> {title};
            #         return;
            #     }
            # }            
            if (defined $dati -> {watched}[0] -> {show} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {show} -> {title}, " S", $dati -> {watched}[0] -> {episode} -> {season}, "E", $dati -> {watched}[0] -> {episode} -> {number}, "\x02.";
            }
            if (defined $dati -> {watched}[0] -> {movie} -> {title})
            {
                say $irc "PRIVMSG $channel :$tktnick last watched \x02", $dati -> {watched}[0] -> {movie} -> {title} . "\x02";
            }
        }
    }
}    
1;
