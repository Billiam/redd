require "set"

module Redd
  module Clients
    class Unauthenticated
      # Non-API methods that make dealing with comments easier.
      module Stream
        # A set which removes the first inserted element when the maximum is
        # reached. This one totally implements the set interface.
        #
        # Similar to PRAW's implementation. (GPL license)
        # @see http://git.io/uA8RVw
        class BoundedOrderedSet < Set
          attr_reader :limit

          def initialize(limit = 10, enum = nil, &block)
            @limit = limit
            @fifo  = []
            super(enum, &block)
          end

          def push(*items)
            items.each do |item|
              delete(@fifo.shift) if size >= @limit
              @fifo.push(item) if add?(item)
            end
            self
          end

          def to_a
            @fifo
          end
        end

        def comment_stream(*args, &block)
          submission_stream(:comments, *args, &block)
        end

        def submission_stream(listing, subreddit = nil, params = {})
          set = BoundedOrderedSet.new

          loop do
            # Get the latest comments from the subreddit. By the way, this line
            #   is the one where the sleeping/rate-limiting happens.
            objects = get_listing(listing, subreddit, params)
            unless objects.empty?
              # Run the loop for each of the new comments accessed.
              objects.reverse_each do |thing|
                yield thing unless set.include?(thing.id)
                set.push(thing.id)
              end
              # Set the latest comment.
              params[:before] = objects.first.fullname
            end
          end
        end
      end
    end
  end
end