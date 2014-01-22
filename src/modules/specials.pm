package csbot2::specials;
use strict;
use warnings;
use feature "say";

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    say $irc "PRIVMSG $channel :~" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*tilde.*$/i;
    say $irc "PRIVMSG $channel :`" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*backtick.*$/i;
    say $irc "PRIVMSG $channel :`~" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*itsdangerous.*$/i; #to go alone, take these!
    say $irc "PRIVMSG $channel :\x01ACTION headtilts\x01" if $line =~ /^:(.+?)!.+?@.+? PRIVMSG ${channel} :.*shinbo.*$/i;
}
1;
