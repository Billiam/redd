require_relative "thing"

module Redd
  module Objects
    # A comment made on links.
    class Subreddit < Thing
      property :display_name
      property :title

      property :description
      property :description_html

      property :header_img
      property :header_title
      property :header_size

      property :user_is_banned
      property :user_is_contributor
      property :user_is_moderator
      property :user_is_subscriber

      property :submit_text
      property :submit_text_html
      property :submit_link_label
      property :submit_text_label

      property :over18
      property :accounts_active
      property :public_traffic
      property :subscribers
      property :comment_score_hide_mins
      property :subreddit_type
      property :submission_type

      alias_method :header_image, :header_img
      alias_method :nsfw?, :over18
      alias_method :users_online, :accounts_active
      alias_method :type, :subreddit_type

      def created
        @created ||= Time.at(self[:created_utc])
      end

      def url
        @url ||= "http://reddit.com" + self[:url]
      end
    end
  end
end