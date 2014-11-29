require_relative "client"

module Redd
  module Clients
    # The unauthenticated client.
    class Unauthenticated < Client
      mixin :utilities
      mixin :captcha
    end
  end
end
