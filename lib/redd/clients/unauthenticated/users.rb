module Redd
  module Clients
    class Unauthenticated
      # Methods to interact with other redditors
      module Users
        # Return a User object from the username of a redditor.
        # @param username [String] The username.
        # @return [Redd::Object::User]
        def user(username)
          request_object :get, "/user/#{username}/about.json"
        end
      end
    end
  end
end
