package csbot2::specials;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $channel, $nick) = @_;
    say $irc "PRIVMSG $channel :~" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*tilde.*$/i;
    say $irc "PRIVMSG $channel :`" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*backtick.*$/i;
}
1;
