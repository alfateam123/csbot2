package csbot2::textgen;
use strict;
use warnings;

sub parse
{
    my ($line, $irc, $channel) = @_;
    my @w1;
    my @w2;
    my $seed = $ARGV[0];
    my $words;
    my @wordzz;
    
    open my $wordz, "<", "/home/wasp/csbot/words.txt";
    $words .= $_ while <$wordz>;
    close $wordz;

    @wordzz = split /\s/, $words;

    for (1 .. scalar(@wordzz) - 3)
    {
        push @w1, $wordzz[$_ - 1];
        push @w2, $wordzz[$_];
    }

    my $lineret = $seed . " ";
    for (1 .. 10)
    {
        for (1 .. scalar(@w1))
        {
            if ($w1[$_ - 1] eq $seed && int(rand(15)) == 2)
            {
                $lineret .= $w2[$_ - 1] . " ";
                $seed = $w2[$_ - 1];
                last;
            }
        }
    }   

    say $irc "PRIVMSG $channel :$lineret";
}
