# Migrating from 0.6 to 0.7

I rewrote the entirety of Redd to **work only with >= 2.1.1**. Still on lower
versions of Ruby? Upgrading is pretty easy with
  [rbenv-build](https://github.com/sstephenson/ruby-build) or 
  [rvm](http://rvm.io).
If you can't upgrade, check out
  [RedditKit.rb](https://github.com/samsymons/RedditKit.rb),
which is the only other ruby wrapper still being worked on as far as I know.

Main changes include:

* Keyword arguments for some methods.
* `Redd::Base` now inherits from `Hashie::Dash`.
* A new DSL module that can be used like so:

  ```  
  require "redd/dsl"
  include Redd::DSL

  puts client.user_agent
  login("Mustermind", "hunter2") unless logged_in?
  ```
* A new CLI for creating bots quickly.

  ```
  $ redd create picturegamebot
    ...
  $ cd picturegamebot
  $ redd start
    Launching bot with foreman...
  ```
* That's it so far. There might be more changes soon...
