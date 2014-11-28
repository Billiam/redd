require "virtus"

module Redd
  module Objects
    class Comment
      # Creatable
      attribute :author

      # Editable/Saveable/Gildable
      attribute :edited
      attribute :saved
      attribute :gilded

      # Voteable
      attribute :ups
      attribute :downs
      attribute :score
      attribute :likes
      attribute :controversiality

      # Moderateable
      attribute :banned_by
      attribute :approved_by
      attribute :score_hidden
      attribute :distinguished
      attribute :num_reports

      # Commentable
      attribute :parent_id
      attribute :link_id
      attribute :body
      attribute :body_html
      attribute :author_flair_text
      attribute :author_flair_css_class

      alias_method :reports_count, :num_reports
    end
  end
end
