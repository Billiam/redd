require_relative "thing"

module Redd
  module Object
    # The model for private messages
    class PrivateMessage < Thing
      property :body
      property :body_html
      property :subreddit
      property :parent_id
      property :distinguished
      property :was_comment
      property :first_message_name
      property :context

      property :dest
      property :author

      alias_method :from, :author
      alias_method :to, :dest

      def created
        @created ||= Time.at(self[:created_utc])
      end
    end
  end
end