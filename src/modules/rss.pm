package csbot2::rss;
use strict;
use warnings;
use XML::FeedPP;
use feature "say";

my @posts;

sub loadSource{
    my $source = shift;
    @posts = ();

    my $feed;
    
    eval{
        my $source_url=$source;
        $feed = XML::FeedPP->new($source_url);
    };
    
    if ($@)
    {
        print "hey, failed! ".$source;
        return;
    }
    
    foreach my $post ($feed->get_item())
    {
        my $title = $post->title;
        $title =~ s/(\t|\n)/ /g;
        $title =~ s/ {2,}/ /g;
        push (@posts, {title => $title, link => $post->link});
    }
}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if(/^:(.+?)!.+?@.+? PRIVMSG ${channel} :rss help/i)
    {
        say $irc "PRIVMSG $channel :(help) rss [number of item to see] <url>";
    }
    elsif (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :rss ([0-9]* ?)(.+?)$/i)
    {
        loadSource($3);
        unless (scalar  @posts)
        {
        say $irc "PRIVMSG $channel :I heard you talkin' shit, man. Please, stop it.";
        }
        else
        {
            my ($index,$limit) = (0, 3);
            $limit = int($2) if $2;
            foreach my $post (@posts)
            {
                say $irc "PRIVMSG $channel :".$post->{"title"}." --> ".$post->{"link"} if $index < $limit;
                $index++;
            }
        }
    }
}    
1;
