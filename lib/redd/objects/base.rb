require "hashie"
require_relative "../clients/unauthenticated"

module Redd
  # A bunch of objects that can hold properties.
  module Objects
    # A base for all objects to inherit from
    class Base < Hashie::Hash
      include Hashie::Extensions::MergeInitializer
      include Hashie::Extensions::MethodReader
      include Hashie::Extensions::MethodQuery

      # @!attribute [r] client
      # @return [Redd::Clients::Client] The client that used to make requests.
      attr_reader :client

      # @param [Hash] attributes A hash of attributes.
      # @param [Redd::Clients::Client] client The client instance.
      def initialize(attributes = {}, client = nil)
        @client ||= Redd::Clients::Unauthenticated.new
        super(attributes)
      end

      private

      def self.alias_property(new_name, old_name)
        define_method(new_name) { send(old_name) }
      end
    end
  end
end
