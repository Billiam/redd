require_relative "../authenticated"

module Redd
  module Clients
    class Unauthenticated
      # Method to login.
      module Account
        # Return the modhash and cookie of the user.
        #
        # @param username [String] The username.
        # @param password [String] The password.
        # @param remember [Boolean] Indicates whether you intend to use the
        #   returned cookie for a long time.
        def login(username, password, remember = false)
          response = post(
            "/api/login", api_type: "json", user: username,
            passwd: password, rem: remember
          )

          data = response[:json][:data]
          Redd::Clients::Authenticated.new(
            data[:cookie],
            data[:modhash]
          )
        end
      end
    end
  end
end
