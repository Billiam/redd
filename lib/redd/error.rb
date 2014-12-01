module Redd
  # An error from reddit
  class Error < StandardError
    attr_reader :code
    attr_reader :headers
    attr_reader :body

    def initialize(env)
      @code = env.status
      @headers = env.response_headers
      @body = env.body
    end

    # rubocop:disable all
    class << self
      def from_response(response)
        status = response[:status]
        body = parse_error(response[:body]).to_s
        case status
        when 200
          case body
          when /ACCESS_DENIED/i             then OAuth2AccessDenied
          when /UNSUPPORTED_RESPONSE_TYPE/i then InvalidResponseType
          when /UNSUPPORTED_GRANT_TYPE/i    then InvalidGrantType
          when /INVALID_SCOPE/i             then InvalidScope
          when /INVALID_REQUEST/i           then InvalidRequest
          when /NO_TEXT/i                   then NoTokenGiven
          when /INVALID_GRANT/i             then ExpiredCode
          when /WRONG_PASSWORD/i            then InvalidCredentials
          when /BAD_CAPTCHA/i               then InvalidCaptcha
          when /RATELIMIT/i                 then RateLimited
          when /BAD_CSS_NAME/i              then InvalidClassName
          when /TOO_OLD/i                   then Archived
          when /TOO_MUCH_FLAIR_CSS/i        then TooManyClassNames
          when /USER_REQUIRED/i             then AuthenticationRequired
          end
        when 400 then BadRequest
        when 401 then InvalidOAuth2Credentials
        when 403
          if /USER_REQUIRED/i =~ body
            AuthenticationRequired
          else
            PermissionDenied
          end
        when 404 then NotFound
        when 409 then Conflict
        when 500 then InternalServerError
        when 502 then BadGateway
        when 503 then ServiceUnavailable
        when 504 then TimedOut
        end
      end

      def parse_error(body)
        return nil unless body.is_a?(Hash)

        if body.key?(:json) && body[:json].key?(:errors)
          body[:json][:errors].first
        elsif body.key?(:jquery)
          body[:jquery]
        elsif body.key?(:error)
          body[:error]
        elsif body.key?(:code) && body[:code] == "NO_TEXT"
          "NO_TEXT"
        end
      end
    end
    # rubocop:enable all

    NoTokenGiven = Class.new(Error)

    ExpiredCode = Class.new(Error)

    InvalidGrantType = Class.new(Error)

    InvalidOAuth2Credentials = Class.new(Error)

    OAuth2AccessDenied = Class.new(Error)

    InvalidResponseType = Class.new(Error)

    InvalidScope = Class.new(Error)

    InvalidRequest = Class.new(Error)

    AuthenticationRequired = Class.new(Error)

    InvalidCaptcha = Class.new(Error)

    BadGateway = Class.new(Error)

    BadRequest = Class.new(Error)

    InvalidMultiredditName = Class.new(Error)

    Conflict = Class.new(Error)

    InternalServerError = Class.new(Error)

    InvalidClassName = Class.new(Error)

    InvalidCredentials = Class.new(Error)

    NotFound = Class.new(Error)

    PermissionDenied = Class.new(Error)

    RequestError = Class.new(Error)

    ServiceUnavailable = Class.new(Error)

    TooManyClassNames = Class.new(Error)

    Archived = Class.new(Error)

    TimedOut = Class.new(Error)

    # Raised when the client needs to wait before making another request
    class RateLimited < Error
      # @!attribute [r] time
      # @return [Integer] The seconds to wait before making another request.
      attr_reader :time

      def initialize(env)
        @time = env[:body][:json][:ratelimit]
        super(env)
      end
    end
  end
end
