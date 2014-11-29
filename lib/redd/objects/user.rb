require_relative "thing"

module Redd
  module Objects
    # The model for a reddit user
    class User < Thing
      property :name
      property :is_friend
      property :link_karma
      property :comment_karma
      property :gold_creddits
      property :gold_expiration
      property :is_gold
      property :is_mod
      property :has_verified_email
      property :has_mod_mail
      property :has_mail
      property :hide_from_robots

      alias_method :has_gold, :is_gold

      def created
        @created ||= Time.at([:created_utc])
      end
    end
  end
end
