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
        def get_info(id: nil, url: nil)
          if id.is_a?(String)
            params = {id: id}
          elsif id.is_a?(Array) && !id.empty?
            params = {id: id.join(",")}
          else
            params = {url: url}
          end

          request_object :get, "/api/info.json", params
        end
        alias_method :comment, :get_info
        alias_method :submission, :get_info
      end
    end
  end
end
