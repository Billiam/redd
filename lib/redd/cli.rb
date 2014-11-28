require "thor"
require_relative "version"

module Redd
  # The command line interface for generating and managing bots.
  class CLI < Thor
    include Thor::Actions
    attr_reader :name

    def self.source_root
      File.join(File.dirname(__FILE__), "../")
    end

    desc "version", "provide current redd version"
    def version
      say "Redd, v#{Redd::VERSION}"
    end

    desc "create NAME", "create a project titled NAME"
    def create(name)
      @name = name
      directory("template", name)
      say "Make sure to modify the .env file.", :yellow
    end
  end
end
