require_relative "thing"

module Redd
  module Objects
    # The model for private messages
    class PrivateMessage < Thing
      alias_property :from, :author
      alias_property :to, :dest

      def created
        @created ||= Time.at(self[:created_utc])
      end
    end
  end
end