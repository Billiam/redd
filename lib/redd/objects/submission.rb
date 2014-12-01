require_relative "thing"

module Redd
  module Objects
    # A submission made in a subreddit.
    class Submission < Thing
      is :editable
      is :hideable
      is :saveable
      is :votable

      alias_property :nsfw?, :over_18
      alias_property :self?, :is_self
      alias_property :comments_count, :num_comments

      def subreddit_name
        @subreddit_name ||= self[:subreddit]
      end

      def created
        @created ||= Time.at(self[:created_utc])
      end

      def permalink
        @permalink ||= "http://www.reddit.com" + self[:permalink]
      end

      def short_url
        @short_url ||= "http://redd.it/" + id
      end

      def gilded?
        @if_gilded ||= gilded > 0
      end
    end
  end
end
