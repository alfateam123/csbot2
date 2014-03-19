#csbot2 docs
###modules API

Csbot2 was thought to be extremely modular, which is basically the reason I switched to perl in the first place. This means it includes a very basic "API", which allows modules to get some data from the main bot module (the socket, data from the user ho sent the message and so on). Modules needs to be in the csbot2::modulename package and they only need to implement two functions: `parse` (executed for every line written on the channel) and `init` (executed just once, when the module is loaded). The parse function gets passed 6 parameters from the main loop:
- The main bot instance
- The message to be parsed
- The socket to write on
- The configuration hash
- The channel csbot2 is in
- The nick csbot2 is using

What you do with those 6 parameters is up to you. The standard module stucture is to use ifs to parse the `$line` variable with regexes and do stuff with it.

You can find an example module in the `barebones.pm` module.

###Modules list
This is a list of the modules included in this repo as of 23/01/2014 and their dependencies:

- `autorejoin.pm`: This module joins the channel csbot2 was in if it gets kicked. It has no special dependencies.
- `barebones.pm`: This module is included as an example and not used by csbot2. No special dependencies.
- `dieroll.pm`: This module rolls a die and prints the result. No dependencies.
- `emergency.pm`: This module insults users when called. No special dependencies.
- `isup.pm`: This module checks if a website is up based on the HTTP response it receives. It needs `LWP::UserAgent` to work.
- `lastfm.pm`: This module is used as a Last.fm interface. It needs `JSON`, `LWP::UserAgent` and an API key defined in the config file.
- `linktitles.pm`: This module prints the `<title>` tag of links posted in the channel. It needs `LWP::UserAgent` and `HTML::Entities` to work.
- `mtg.pm`: This module connects to [magiccards.info](http://magicards.info) and searches for specific cards. It needs `LWP::UserAgent` to work.
- `niggaradio.pm`: This module is kept as an example since the service it connected to no longer exists. It uses the `LWP::UserAgent` module.
- `reddit.pm`: This module links to subreddits mentioned in the channel. No dependencies required.
- `rss.pm`: This module prints the first n elements of an RSS feed. It needs `XML::FeedPP` to work.
- `scp.pm`: This module waits for a SCP to be mentioned and then fetches its name and link from the scp wiki. It needs `LWP::UserAgent` and `HTML::Entities` to work.
- `specials.pm`: This module does special functions useful only to me, basically. No dependencies.
- `trakt.pm`: This module is used as a Trakt interface. It needs `JSON`, `LWP::UserAgent`, `DateTime` and an API key defined in the config file.
