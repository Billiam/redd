require "bundler"
Bundler.require
Dotenv.load

login ENV["USERNAME"], ENV["PASSWORD"]
puts me.name
