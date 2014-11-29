require_relative "base"

module Redd
  module Objects
    # A reddit thing.
    # @see http://www.reddit.com/dev/api#fullnames
    class Thing < Base
      # Check for equality.
      # @param other The other object.
      # @return [Boolean]
      def ==(other)
        other.is_a?(Thing) && full_name == other.full_name
      end

      # @return [String] The fullname of the thing.
      def fullname
        @fullname ||= "#{self[:kind]}_#{self[:id]}"
      end
    end
  end
end
