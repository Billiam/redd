require_relative "redd/version"
require_relative "redd/clients/client"

# The main Redd module.
module Redd
  def self.it(username = nil, password = nil, **kwargs)
    if username && password
      client = Redd::Clients::Client.new
      client.login(username, password, **kwargs)
    else
      Redd::Clients::Unauthenticated.new(**kwargs)
    end
  end
end
