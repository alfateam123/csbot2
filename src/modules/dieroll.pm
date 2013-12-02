package csbot2::dieroll;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if ($line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :roll (\d+)d(\d+)\s*$/i)
    {
        my $total = 0;
        foreach (1..$2)
        {
            $total += int(rand($3));
        }
        say $irc "PRIVMSG $channel :$total";
    }
}    
1;
