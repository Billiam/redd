require_relative "thing"

module Redd
  module Objects
    # A comment that can be made on a link.
    class Comment < Thing
      # Creatable
      property :author

      # Editable/Saveable/Gildable
      property :edited
      property :saved
      property :gilded

      # Voteable
      property :ups
      property :downs
      property :score
      property :likes
      property :controversiality

      # Moderatable
      property :banned_by
      property :approved_by
      property :score_hidden
      property :distinguished
      property :num_reports

      # Commentable
      property :parent_id
      property :link_id
      property :body
      property :body_html
      property :author_flair_text
      property :author_flair_css_class

      alias_method :reports_count, :num_reports
    end
  end
end
