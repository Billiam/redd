require "faraday_middleware/response_middleware"

module Redd
  # The module that contains middleware that alters the Faraday response.
  module Response
    # Faraday Middleware that raises an error if there's one.
    class RaiseError < FaradayMiddleware::ResponseMiddleware
      def parse_response?(env)
        @error = Redd::Error.from_response(env)
      end

      def process_response(env)
        fail @error.new(env) if @error
      end
    end
  end
end
