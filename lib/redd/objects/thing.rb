require_relative "base"

module Redd
  module Objects
    # A reddit thing.
    # @see http://www.reddit.com/dev/api#fullnames
    class Thing < Base
      # @!attribute [r] id
      # @return [String] The id value for the thing.
      property :id

      # @!attribute [r] kind
      # @return [String] The kind of the thing.
      property :kind

      # Check for equality.
      # @param other The other object.
      # @return [Boolean]
      def ==(other)
        other.is_a?(Redd::Thing) && full_name == other.full_name
      end

      # @return [String] The fullname of the thing.
      def fullname
        @fullname ||= "#{[:kind]}_#{[:id]}"
      end

      private

      # There are some useless properties and there are seme
      def assert_property_exists!(*)
        nil
      end
    end
  end
end
