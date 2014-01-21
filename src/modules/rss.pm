package csbot2::rss;
use strict;
use warnings;
use feature "say";

#use JSON;
use XML::FeedPP;
#use List::Util qw(shuffle); #useful on catgirls, not here 
#use LWP::Simple; #for tumblr 1280 image test

#my $hasLoaded=0;
my @posts;
#my @shownPosts;
#now they are read from file.
#my $sources=();
#my @unloaded_sources=();

sub loadSource{
    my $source = shift;
    @posts = ();
    @shownPosts = ();
    #@sources=loadSources();

    my $feed;
    eval{
    	my $source_url=buildUrl($source);
        $feed = XML::FeedPP->new($source_url);
    };
    if ($@)
    {
        print "hey, failed! ".buildUrl($source);
        #push(@unloaded_sources, $source);
        return; #next; 
    }
    #end bugfix #5
    foreach my $post ($feed->get_item())
    {
        #my $source_type = lc $sources->{$source}->{'source_type'};
        #my $cat_image_link='no es fake, senor!';
        #my $isgoodpost = 0;

        #($cat_image_link, $isgoodpost) = extractFromReddit($post) if $source_type eq 'reddit';
        #($cat_image_link, $isgoodpost) = extractFromTumblr($post) if $source_type eq 'tumblr';
    
        push (@posts, (:title => $post->title, :link => $post->link)) ;#if $isgoodpost; #@cat);
    }

}

sub parse
{
    my ($self, $line, $irc, $config, $channel, $nick) = @_;
    if (/^:(.+?)!.+?@.+? PRIVMSG ${channel} :rss (.+?)$/i)
    {
        loadSources($1);
        foreach my $post (@posts)
        {
        	say $irc "PRIVMSG $channel :".$post->{"title"}." --> ".$post->{"link"};
        }
        #say $irc "PRIVMSG $channel :output.";
    }
}    
1;
