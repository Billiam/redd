module Redd
  module Clients
    class Authenticated
      # Methods for sending and reading private messages
      module PrivateMessages
        # Block the sender of the message from sending any more.
        #
        # @param message [Redd::Objects::PrivateMessage, String] The message
        #   whose sender to block.
        def block_message(message)
          fullname = get_property(message, :fullname)
          post "/api/block", id: fullname
        end

        # Compose a message to a person or the moderators of a subreddit.
        #
        # @param to [Redd::Objects::User, Redd::Objects::Subreddit, String] The
        #   thing to send a message to.
        # @param subject [String] The subject of the message.
        # @param text [String] The message text.
        # @param captcha [String] A possible captcha result to send if one
        #   is required.
        # @param iden [String] The identifier for the captcha if one
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
        # @param message [Redd::Objects::PrivateMessage, String] The message
        #   to mark as read.
        def mark_as_read(message)
          fullname = get_property(message, :fullname)
          post "/api/read_message", id: fullname
        end

        # Mark a message as unread.
        #
        # @param message [Redd::Objects::PrivateMessage, String] The message
        #   to mark as unread.
        def mark_as_unread(message)
          fullname = get_property(message, :fullname)
          post "/api/unread_message", id: fullname
        end

        # Return a list of a user's private messages.
        #
        # @param category [String] The category of messages to view.
        # @param mark [Boolean] Whether to remove the orangered from the
        #   user's inbox. 
        # @param params [Hash] A list of params to send with the request.
        # @option params [String] :after Return results after the given
        #   fullname.
        # @option params [String] :before Return results before the given
        #   fullname.
        # @option params [Integer] :count (0) The number of items already seen
        #   in the listing.
        # @option params [1..100] :limit (25) The maximum number of things to
        #   return.
        def messages(category = "inbox", mark = false, params = {})
          params[:mark] = mark
          request_object :get, "/message/#{category}.json", params
        end
      end
    end
  end
end