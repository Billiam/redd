require_relative "unauthenticated"

module Redd
  module Clients
    # The authenticated client.
    class Authenticated < Unauthenticated
      mixin :account
      mixin :links_comments
      mixin :private_messages

      # @!attribute [r] cookie
      # @return [String] The cookie used to store the current session.
      attr_reader :cookie

      # @!attribute [r] modhash
      # @return [String] The modhash used when making requests.
      attr_reader :modhash

      # Set up an authenticated connection to reddit.
      #
      # @param [String] cookie The cookie to use when sending a request.
      # @param [String] modhash The modhash to use when sending a request.
      # @param [Hash] **kwargs Keyword arguments to pass to the Client.
      # @see Client
      def initialize(cookie, modhash, **kwargs)
        @cookie = cookie
        @modhash = modhash
        super(**kwargs)
      end

      private

      # @return [Hash] The headers that are sent with every request.
      def headers
        @headers ||= {
          "User-Agent" => @user_agent,
          "Cookie" => "reddit_session=#{@cookie}",
          "X-Modhash" => @modhash
        }
      end
    end
  end
end
