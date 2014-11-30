module Redd
  module Clients
    class Unauthenticated
      # Methods to location links and comments.
      module LinksComments
        # @option [Array<String>] id An array of fullnames.
        # @option [String] url The url of a thing. If an id is also
        #   provided, the id will take precedence.
        # @return [Redd::Objects::Listing] Listing of the object or objects.
        #
        # @note Reddit does accept a subreddit, but with fullnames and urls, I
        #   assumed that was unnecessary.
        def get_info(id: [], url: "")
          if !id.empty?
            params = {id: id.join(",")}
          else
            params = {url: url}
          end

          object_from_response :get, "/api/info.json", params
        end
        alias_method :get_info, :comment
        alias_method :get_info, :submission
      end
    end
  end
end
