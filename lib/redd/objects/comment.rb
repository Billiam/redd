require_relative "thing"

module Redd
  module Objects
    # A comment that can be made on a link.
    class Comment < Thing
      alias_property :reports_count, :num_reports
    end
  end
end
