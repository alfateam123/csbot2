package csbot2::rss;
use strict;
use warnings;
use feature "say";

#use JSON;
use XML::FeedPP;
#use LWP::Simple; #for tumblr 1280 image test
use Data::Dumper;

#my $hasLoaded=0;
my @posts;
my @shownPosts;
#now they are read from file.
my $sources=();
my @unloaded_sources=();

sub loadSource{
    my $source = shift;
    @posts = ();
    @shownPosts = ();
    #@sources=loadSources();

    my $feed;
    eval{
    	  my $source_url=$source; #buildUrl($source);
        $feed = XML::FeedPP->new($source_url);
    };
    if ($@)
    {
        print "hey, failed! ".$source;#buildUrl($source);
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
    
        my $title = $post->title;
        $title =~ s/(\t|\n)/ /g; #spaces are important, nowadays
        $title =~ s/ {2,}/ /g; #here too...

        push (@posts, {title => $title, link => $post->link}) ;#if $isgoodpost; #@cat);
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
        #say Dumper($post);
    	  say $irc "PRIVMSG $channel :".$post->{"title"}." --> ".$post->{"link"} if $index < $limit;
        $index++;
      }
    }
    #say $irc "PRIVMSG $channel :output.";
  }
}    
1;
