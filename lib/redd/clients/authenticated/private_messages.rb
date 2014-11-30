module Redd
  module Clients
    class Authenticated
      # Methods for sending and reading private messages
      module PrivateMessages
        # Block the sender of the message from sending any more.
        #
        # @param [Redd::Objects::PrivateMessage, String] message The message
        #   whose sender to block.
        def block_message(message)
          fullname = get_property(message, :fullname)
          post "/api/block", id: fullname
        end

        # Compose a message to a person or the moderators of a subreddit.
        #
        # @param [Redd::Objects::User, Redd::Objects::Subreddit, String] to The
        #   thing to send a message to.
        # @param [String] subject The subject of the message.
        # @param [String] text The message text.
        # @param [String] captcha A possible captcha result to send if one
        #   is required.
        # @param [String] iden The identifier for the captcha if one
        #   is required.
        def compose_message(to:, subject:, text:, captcha: nil, iden: nil)
          params = {api_type: "json", subject: subject, text: text}
          params << {captcha: captcha, iden: iden} if captcha
          params[:to] = get_property(to, :name) ||
                        get_property(to, :display_name)

          post "/api/compose", params
        end

        # Mark a message as read.
        #
        # @param [Redd::Objects::PrivateMessage, String] message The message
        #   to mark as read.
        def mark_as_read(message)
          fullname = get_property(message, :fullname)
          post "/api/read_message", id: fullname
        end

        # Mark a message as unread.
        #
        # @param [Redd::Objects::PrivateMessage, String] message The message
        #   to mark as unread.
        def mark_as_unread(message)
          fullname = get_property(message, :fullname)
          post "/api/unread_message", id: fullname
        end

        # Return a list of a user's private messages.
        #
        # @param [String] category The category of messages to view.
        # @param [Boolean] mark Whether to remove the orangered from the
        #   user's inbox.
        # @param [String] after Return results after the given fullname.
        # @param [String] before Return results before the given fullname.
        # @param [Integer] count The number of items already seen in the
        #   listing.
        # @param [1..100] limit The maximum number of things to return.
        def messages(
          category = "inbox", mark: false, after: nil, before: nil, count: 0,
          limit: 25
        )
          params = {mark: mark, count: count, limit: limit}
          params[:after] = after if after
          params[:before] = before if before
          request_object :get, "/message/#{category}.json", params
        end
      end
    end
  end
end