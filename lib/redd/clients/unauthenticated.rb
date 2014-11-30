require_relative "client"

module Redd
  module Clients
    # The unauthenticated client.
    class Unauthenticated < Client
      mixin :utilities

      mixin :account
      mixin :captcha
      mixin :links_comments
      mixin :subreddits
      mixin :users
      mixin :wiki
    end
  end
end
