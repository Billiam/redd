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
* Objects no longer have predefined properties.
* Listings are just arrays on steroids and Objects are just hashes on steroids.
* **`(in progress)`** A new DSL module that can be used like so:

  ```ruby
  require "redd/dsl"
  include Redd::DSL

  puts client.user_agent
  login("Mustermind", "hunter2") unless logged_in?
  ```
* **`(in progress)`** Moving all methods from the client to the respective
  objects, sorta similar to Rails' models. This will be helpful in cleaning up
  the large sets of methods in the client folders and the base folder.
  
  ```ruby
  # previously:
  r = Redd::Client::Unauthenticated.new
  r.get_user_submitted("Mustermind")

  # now
  r = Redd.it
  r.user(name: "Mustermind").get_submitted
  ```
* A new CLI for creating bots quickly.

  ```shell
  $ redd create picturegamebot --username Mustermind --password hunter2
    ...
  $ cd picturegamebot
  $ bundle exec foreman start
  ```
* That's it so far. There might be more changes soon...
