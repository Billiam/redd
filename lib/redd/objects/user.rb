require_relative "thing"

module Redd
  module Objects
    # The model for a reddit user
    class User < Thing
      alias_property :has_gold, :is_gold

      def created
        @created ||= Time.at(self[:created_utc])
      end
    end
  end
end
