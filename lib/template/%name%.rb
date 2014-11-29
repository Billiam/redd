require "bundler"
Bundler.require

include Redd::DSL

login ENV["USERNAME"], ENV["PASSWORD"]
puts me.name
