require_relative "redd/version"
require_relative "redd/clients/authenticated"
require_relative "redd/clients/unauthenticated"

# The main Redd module.
module Redd
  def self.new(username: nil, password: nil)
    if username && password
      Redd::Clients::Authenticated.new(username, password)
    else
      Redd::Clients::Unauthenticated.new
    end
  end
end
