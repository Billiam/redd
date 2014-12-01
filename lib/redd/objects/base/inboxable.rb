module Redd
  module Objects
    class Base
      # An item that can be in a user's inbox.
      module Inboxable
        # Mark the item as read.
        def mark_as_read
          client.mark_as_read(self)
        end

        # Mark the item as unread.
        def mark_as_unread
          client.mark_as_unread(self)
        end

        # Reply to the comment or message.
        def reply(text)
          client.reply(self, text)
        end
      end
    end
  end
end
