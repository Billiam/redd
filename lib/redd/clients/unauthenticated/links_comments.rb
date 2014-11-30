module Redd
  module Clients
    class Unauthenticated
      module LinksComments
        # @param params [Hash] A hash of parameters to send to reddit.
        # @option params [String] :id The fullname of a thing.
        # @option params [String] :url The url of a thing. If an id is also
        #   provided, the id will take precedence.
        # @return [Redd::Objects::Listing] Listing of the object or objects.
        #
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(params = {})
          object_from_response :get, "/api/info.json", params
        end
      end
    end
  end
end