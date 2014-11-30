module Redd
  module Clients
    class Unauthenticated
      # Methods to location links and comments.
      module LinksComments
        # Get a listing of comments for a submission.
        # @param [Redd::Objects::Submission, String] submission The submission
        #   or the id (not fullname!)
        # @return [Redd::Objects::Listing] A listing of comments.
        def request_comments(submission)
          id = get_property(submission, :id)
          body = get("/comments/#{id}.json")[1]
          object_from_body(body)
        end

        # Get a listing of objects based on their fullnames or url.
        #
        # @param [String, Array<String>] id An array of fullnames or a single
        #   one.
        # @param [String] url The url of a thing. If an id is also
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

        # Get a listing of objects based on their ids. Prefer {#get_info}.
        # @param [Array<String>] *ids
        # @return [Redd::Objects::Listing] Listing of the object or objects.
        # @see #get_info
        def by_id(*ids)
          get_info(id: ids)
        end
      end
    end
  end
end
