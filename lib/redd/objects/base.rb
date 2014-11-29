require "hashie/dash"

module Redd
  module Objects
    # A base for all objects to inherit from
    class Base < Hashie::Dash
      private

      # There are some useless properties and there are some I'd rather design
      # custom accessor for.
      def assert_property_exists!(*)
        nil
      end
    end
  end
end
