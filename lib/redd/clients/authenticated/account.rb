module Redd
  module Clients
    class Authenticated
      # Methods to manage the logged-in user
      module Account
        # @return [Redd::Objects::User] The logged-in user.
        def me
          request_object :get, "/api/me.json"
        end
      end
    end
  end
end
