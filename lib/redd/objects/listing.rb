module Redd
  module Objects
    # A collection of reddit things.
    # @see https://www.reddit.com/dev/api#listings
    class Listing
      include Enumerable
      extend Forwardable
      def_delegators :@children, :[], :length, :size, :each, :map, :empty?

      # @!attribute [r] children
      # @return [Array] A list of things in the listing.
      attr_reader :children

      # @!attribute [r] kind
      # @return ["listing"]
      attr_reader :kind

      # @!attribute [r] before
      # @return [String] The id of the object before the listing.
      attr_reader :before

      # @!attribute [r] after
      # @return [String] The id of the object after the listing.
      attr_reader :after

      def initialize(children: [], before:, after:)
        @kind = "Listing".freeze
        @children = children
        @before = before
        @after = after
      end
    end
  end
end
