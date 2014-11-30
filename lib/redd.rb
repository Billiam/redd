require_relative "redd/version"
require_relative "redd/clients/authenticated"
require_relative "redd/clients/unauthenticated"

# The main Redd module.
module Redd
  class << self
    def new(username = nil, password = nil)
      if username && password
        Redd::Clients::Unauthenticated.new.login(username, password)
      else
        Redd::Clients::Unauthenticated.new
      end
    end
    alias_method :it, :new
  end
end
