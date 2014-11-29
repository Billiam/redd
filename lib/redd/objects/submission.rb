require_relative "thing"

module Redd
  module Objects
    # A submission made in a subreddit.
    class Submission < Thing
      # Creatable
      property :author

      # Editable/Saveable/Gildable/Hideable
      property :edited
      property :saved
      property :gilded
      property :clicked
      property :visited
      property :stickied
      property :hidden

      # Voteable
      property :ups
      property :downs
      property :score
      property :likes

      # Moderatable
      property :banned_by
      property :approved_by
      property :distinguished
      property :num_reports

      # Flairable
      property :link_flair_text
      property :link_flair_css_class
      property :author_flair_css_class
      property :author_flair_text

      # Submission
      property :domain
      property :media
      property :media_embed
      property :selftext
      property :selftext_html
      property :secure_media
      property :secure_media_embed
      property :over_18
      property :thumbnail
      property :is_self
      property :url
      property :title
      property :num_comments

      alias_method :nsfw?, :over_18
      alias_method :self?, :is_self
      alias_method :comments_count, :num_comments

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