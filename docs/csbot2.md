#csbot2 docs
###general introduction

Table of contents:    
1 General introduction    
2 Csbot2's code explaination    
3 Dependencies list    
    
###1: General introduction
csbot2 is beta software. You should use it accordingly and not come to me if it breaks your server (?).    

Welcome to csbot2's docs! This really short series of documents will help you understand how csbot2 works and how to write modules for it. It's a pretty simple process and modules are basically normal perl modules, free to do whatever they want. You'll get more info about it in the `modules.md` file, that explains how a module is built, what data it gets from the main module and what to do with it. It also lists the currently working modules and their dependencies.        

The `config.md` file explains the configuration file and how you should use it to customize your instance of csbot2. It's a really simple configuration process and, being written in JSON, it's easy to write and modify. Hope you like it.    

This file explains how the main module works and how to modify it if you ever need to. It also lists the dependencies you need for the main bot code to work.    

###2: Csbot2's code explaination
The first thing csbot does, of course after loading modules, is opening the config file and parsing it. This means that _the config file is required_. It needs to be named `config.json` and placed in the same folder as `csbot2.pl`. After the succesful loading of the config file it decodes the JSON in a hash variable and then proceeds to load the modules listed in the configuration, failing horribly if they don't exist or contain errors. If that works, it goes on to load the rest of the config into variables and then opens a TCP socket connecting to the specified server:port, again failing horribly if that doesn't work. Once the socket is open and working, csbot2 sends its nickname and USER information to the server and then enters the main loop, where it parses new lines received on the socket and does stuff with them (responds to PINGs, QUITs if a master asks him to, authenticates with nickserv if needed and so on). It then calls the loaded modules and waits for them to do stuff.    

That's it. Was it so hard to understand? Hope not!    

###3: Dependencies list
The main module of csbot actually requires almost no dependencies, leaving all that shit to modules. It requires perl (a decently updated version, as it uses the `say` function to avoid printing newlines as they are the bane of my existence), some modules from the standard library (`strict`, `warnings`, `diagnostics` and `IO::Socket::INET`/`IO::Socket::SSL`) and just one module from CPAN, `JSON`. It's easily installed, just run `cpan JSON` and you're done.
