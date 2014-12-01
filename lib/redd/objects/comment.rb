require_relative "thing"

module Redd
  module Objects
    # A comment that can be made on a link.
    class Comment < Thing
      is :editable
      is :inboxable
      is :saveable
      is :votable

      alias_property :reports_count, :num_reports
    end
  end
end
