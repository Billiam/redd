require "faraday"
require_relative "../response/raise_error"
require_relative "../response/parse_json"
require_relative "../version"
require_relative "../rate_limit"

module Redd
  # The possible clients that can be used.
  module Clients
    # The basic client to inherit from.
    class Client
      # @!attribute [rw] api_endpoint
      # @return [String] The site to connect to.
      attr_accessor :api_endpoint

      # @!attribute [rw] user_agent
      # @return [String] The user-agent used to communicate with reddit.
      attr_accessor :user_agent

      # @!attribute [rw] rate_limit
      # @return [#after_limit] The handler that takes care of rate limiting.
      attr_accessor :rate_limit

      # Set up an unauthenticated connection to reddit.
      #
      # @param [Hash] options A hash of options to connect using.
      # @option options [#after_limit] :rate_limit The handler that takes care
      #   of rate limiting.
      # @option options [String] :user_agent The User-Agent string to use in the
      #   header of every request.
      # @option options [String] :api_endpoint The main domain to connect
      #   to, in this case, the URL for reddit.
      def initialize(options = {})
        @rate_limit = options[:rate_limit] || Redd::RateLimit.new
        @user_agent = options[:user_agent] || "Redd/Ruby, v#{Redd::VERSION}"
        @api_endpoint = options[:api_endpoint] || "https://www.reddit.com/"
      end

      private

      # @return [Hash{String => String}] A hash of headers.
      def headers
        @request ||= {"User-Agent" => @user_agent}
      end

      # @return [Faraday::RackBuilder] The middleware to use when creating the
      #   connection.
      def middleware
        @middleware ||= Faraday::RackBuilder.new do |builder|
          builder.use Faraday::Request::UrlEncoded
          builder.use Redd::Response::RaiseError
          builder.use Redd::Response::ParseJson
          builder.adapter Faraday.default_adapter
        end
      end

      # @return [Faraday::Connection] A new or existing connection.
      def connection
        @connection ||= Faraday::Connection.new(
          url: api_endpoint,
          headers: headers,
          builder: middleware
        )
      end

      # Send a request to the given path.
      #
      # @param [#to_sym] method The HTTP verb to use.
      # @param [String] path The path under the API endpoint to request from.
      # @param [Hash{String => String}] params The additional parameters to
      #   send.
      # @return [Faraday::Response] The faraday response.
      def request(method, path, params = nil)
        rate_limit.after_limit do
          connection.send(method.to_sym, path, params)
        end
      end

      # @!method get
      # @!method post
      # @!method put
      # @!method delete
      #
      # Sends the request to the given path with the given params and return
      # the body of the response.
      # @param path
      # @param params
      # @see #request
      [:get, :post, :put, :delete].each do |meth|
        define_method(meth) do |path, params = nil|
          request(meth, path, params).body
        end
      end
    end
  end
end
