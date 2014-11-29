require "thor"
require_relative "version"

module Redd
  # The command line interface for generating and managing bots.
  module CLI
    # Create a new Project.
    class Create < Thor::Group
      include Thor::Actions

      argument :name
      class_option :username, aliases: ["-u"], default: "UPDATE_USERNAME"
      class_option :password, aliases: ["-p"], default: "UPDATE_PASSWORD"
      class_option :ruby, aliases: ["-r"], default: "2.1"

      def self.source_root
        File.join(File.dirname(__FILE__), "../")
      end

      def create
        directory "template", name
      end

      # Copied from Rails (MIT License)
      def bundle_command
        say_status :run, "bundle install"
        bundle_command = Gem.bin_path("bundler", "bundle")

        require "bundler"
        inside name do
          Bundler.with_clean_env do
            output = `"#{Gem.ruby}" "#{bundle_command}" install`
            print output
          end
        end
      end
    end

    # The entry point for the CLI.
    class Main < Thor
      include Thor::Actions

      desc "version", "provide current redd version"
      def version
        say "Redd, v#{Redd::VERSION}"
      end

      register Create, "create", "create NAME", "create a project titled NAME"
      tasks["create"].options = Create.class_options
    end
  end
end
