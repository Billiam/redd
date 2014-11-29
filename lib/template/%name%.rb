require "bundler"
Bundler.require

login ENV["USERNAME"], ENV["PASSWORD"]
puts me.name
