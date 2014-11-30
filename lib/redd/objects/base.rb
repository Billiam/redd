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
        @client = client || Redd::Clients::Unauthenticated.new
        super(attributes)
      end

      # @param [Symbol] new_name
      # @param [Symbol] old_name
      def self.alias_property(new_name, old_name)
        define_method(new_name) { send(old_name) }
      end

      # Helper method to require and include a mixin.
      # @param [Symbol] mixin_name A module to load.
      def self.mixin(mixin_name)
        camel_case = mixin_name.to_s.split("_").map(&:capitalize).join
        require_relative "base/#{mixin_name}"
        include Base.const_get(camel_case)
      end
    end
  end
end
