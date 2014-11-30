module Redd
  module Clients
    class Unauthenticated
      # Methods to interact with subreddit wikis
      module Wiki
        # Get a list of pages in the subreddit wiki.
        # @param [Redd::Object::Subreddit, String] subreddit The subreddit to
        #   look in.
        # @return [Array] An array of wikipage titles.
        def get_wikipages(subreddit = nil)
          name = get_property(subreddit, :display_name)

          path = "/wiki/pages.json"
          path.prepend("/r/#{name}") if subreddit
          get(path)[:data]
        end

        # Get a wiki page.
        # @param [String] page The title of the wiki page.
        # @param [Redd::Object::Subreddit, String] subreddit The subreddit to
        #   look in.
        # @return [Redd::Object::WikiPage] A wiki page.
        def wikipage(page, subreddit = nil)
          name = get_property(subreddit, :display_name)

          path = "/wiki/#{page}.json"
          path.prepend("/r/#{name}") if subreddit
          request_object :get, path
        end
      end
    end
  end
end
