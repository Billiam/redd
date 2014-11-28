require_relative "clients/unauthenticated"
require_relative "clients/authenticated"

module Redd
  # The DSL can can be implemented in any bot.
  # @example A Simple Example
  #   require "redd/dsl"
  #
  #   class TestBot
  #     include Redd::DSL
  #
  #     def initialize
  #       login "username", "password"
  #     end
  #   end
  #
  module DSL
    class << self
      private

      # Create or access the client.
      # @return [Redd::Clients::Client] The client.
      def client
        @client ||= Redd::Clients::Unauthenticated.new
      end

      # Login with the username and password and replace the client with the
      # logged in one.
      #
      # @param [String] username
      # @param [String] password
      # @return [Redd::Clients::Client] The logged-in client.
      def login(username, password)
        @client = Redd::Clients::Unauthenticated.new(username, password)
      end

      # @return [Boolean] If the current user is logged in.
      def logged_in?
        !@client.is_a?(Redd::Clients::Unauthenticted)
      end

      # Reset the client back to the unauthenticated one.
      # @return [Redd::Clients::Client] The unauthenticated client.
      def logout!
        @client = Redd::Clients::Unauthenticated.new
      end
      alias_method :reset_client!, :logout!

      # @see http://git.io/KNmwIw
      def method_missing(meth, *args, &block)
        return super unless @client.respond_to?(meth)
        @client.send(meth, *args, &block)
      end
    end
  end
end
