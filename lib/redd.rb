require_relative "redd/version"
require_relative "redd/clients/unauthenticated"

# The main Redd module.
module Redd
  def self.it(username = nil, password = nil, **kwargs)
    if username && password
      Redd::Clients::Unauthenticated.new.login(username, password, **kwargs)
    else
      Redd::Clients::Unauthenticated.new(**kwargs)
    end
  end
end
