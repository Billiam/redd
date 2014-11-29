require_relative "unauthenticated"

module Redd
  module Clients
    # The authenticated client.
    class Authenticated < Unauthenticated
      mixin :account

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
      # @param [Hash] options A hash of options to connect using.
      # @option options [#after_limit] :rate_limit The handler that takes care
      #   of rate limiting.
      # @option options [String] :user_agent The User-Agent string to use in the
      #   header of every request.
      # @option options [String] :api_endpoint The main domain to connect to, in
      #   this case, the URL for reddit.
      def initialize(cookie, modhash, options = {})
        super(options)
        @cookie = cookie
        @modhash = modhash
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
