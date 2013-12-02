package csbot2::autorejoin;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    say $irc "JOIN $channel" if $line =~ /^:.+?!.+?@.+? KICK $channel $nick.*$/i;
}
1;
