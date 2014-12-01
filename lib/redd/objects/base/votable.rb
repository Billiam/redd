module Redd
  module Objects
    class Base
      # An item that can be voted upon
      module Votable
        # Upvote the item.
        def upvote
          client.upvote(self)
        end

        # Downvote the item.
        def downvote
          client.downvote(self)
        end

        # Remove the vote on the item.
        def unvote
          client.unvote(self)
        end
        alias_method :clear_vote, :unvote
      end
    end
  end
end
