#csbot2 docs
###configuration file

The configuration file is the most important part of csbot2, as without it nothing works. It's designed to be as simple as possible to use from code and to write by hand.    

All the configuration is contained in a json file (`config.json`) placed in the same folder as the main `csbot2.pl` file. It contains a main hash that is then separated in 5 parts: the main configuration (hash, it contains basic options for the main module), the API keys section (hash, it contains the API keys needed to access online services from the various modules), traktaliases (hash, it contains aliases in the form "irc username": "trakt username"), lastfmaliases (hash, works exactly like traktaliases) and the modules array, containing csbot2 modules to be loaded.    

###1: main configuration
The main configuration hash contains basic informations like the server/channel to connect to, the nick to use and so on. They are:
- "server": the hostname/ip of the irc server;
- "port": the port to connect to, most server run raw tcp on 6667 and SSL on 6697;
- "ssl": 0 if the connection is raw tcp/1 if SSL is to be used;
- "channel": the channel to connect to;
- "nick": the nickname to use;
- "password": The NickServ password to use (if the nickname is registered);
- "masters": array, contains the nicknames of "master" users allowed to run important commands;
- "randomchars": not used as of 22/01/2014;
- "quitline": not used as of 22/01/2014;

###2: api keys
This section contains the varius API keys for online services used by modules. Right now it contains just the keys for Last.fm and Trakt.

###3: traktaliases
This section contains aliases to be used in the trakt module. They need to be in the form "irc user": "trakt user".

###4: lastfmaliases
This section contains aliases to be used in the lastfm module. They work exactly like the ones used in the trakt module.

###5: modules
This section contains an array listing modules to be loaded when the bot starts up. They need to be placed in the `modules` subfolder placed in the same folder as the main `csbot2.pl` file to be correctly recognized by perl.
