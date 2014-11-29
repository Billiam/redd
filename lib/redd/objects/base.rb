require "hashie/dash"
require_relative "../clients/unauthenticated"

module Redd
  # A bunch of objects that can hold properties.
  module Objects
    # A base for all objects to inherit from
    class Base < Hashie::Dash

      # @!attribute [r] client
      # @return [Redd::Clients::Client] The client that used to make requests.
      attr_reader :client

      # @param [Hash] attributes A hash of attributes.
      # @param [Redd::Clients::Client] client The client instance.
      def initialize(attributes = {}, client = nil, &block)
        @client ||= Redd::Clients::Unauthenticated.new
        super(attributes, &block)
      end

      private

      # There are some useless properties and there are some I'd rather design
      # custom accessor for.
      def assert_property_exists!(*)
        nil
      end
    end
  end
end
