require "faraday_middleware/response_middleware"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that parses JSON using OJ, via MultiJson.
    class ParseJson < FaradayMiddleware::ResponseMiddleware
      dependency "multi_json"

      define_parser do |body|
        begin
          MultiJson.load(body, symbolize_keys: true)
        rescue MultiJson::ParseError
          body
        end
      end

      def parse_response?(env)
        response_type(env).include?("json")
      end
    end
  end
end
