require "faraday"
require_relative "../response/raise_error"
require_relative "../response/parse_json"
require_relative "../version"
require_relative "../error"
require_relative "../rate_limit"

require_relative "client/utilities"
require_relative "client/account"

module Redd
  # The possible clients that can be used.
  module Clients
    # The basic client to inherit from.
    class Client
      include Utilities
      include Account

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
      # @param [#after_limit] rate_limit The handler that takes care of rate
      #   limiting.
      # @param [String] user_agent The User-Agent string to use in the header
      #   of every request.
      # @param [String] api_endpoint The main domain to connect to, in this
      #   case, the URL for reddit.
      def initialize(rate_limit: nil, user_agent: nil, api_endpoint: nil)
        @rate_limit = rate_limit || RateLimit.new
        @user_agent = user_agent || "Redd/Ruby, v#{Redd::VERSION}"
        @api_endpoint = api_endpoint || "https://www.reddit.com/"
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
        @rate_limit.after_limit do
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

      # Helper method to require and include a mixin.
      # @param [Symbol] mixin_name A module to load.
      def self.mixin(mixin_name)
        class_name = name.split("::").last.downcase
        camel_case = mixin_name.to_s.split("_").map(&:capitalize).join
        require_relative "#{class_name}/#{mixin_name}"
        include const_get(camel_case)
      end
    end
  end
end
