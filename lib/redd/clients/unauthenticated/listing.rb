module Redd
  module Clients
    class Unauthenticated
      # Most methods that return listings.
      module Listing
        # @!method get_hot
        # @!method get_new
        # @!method get_top
        # @!method get_controversial
        # @!method get_comments
        #
        # Get the appropriate listing.
        # @param [Redd::Object::Subreddit] subreddit The subreddit to query.
        # @param [Hash] kwargs A list of params to send with the request.
        # @return [Redd::Object::Listing]
        #
        # @see #get_listing
        %w(hot new top controversial comments).each do |sort|
          define_method :"get_#{sort}" do |subreddit = nil, **kwargs|
            get_listing(sort, subreddit, **kwargs)
          end
        end

        private

        # Get the front page of reddit or a subreddit sorted by type.
        #
        # @param [:hot, :new, :random, :top, :controversial, :comments] type
        #   The type of listing to return 
        # @param [Redd::Objects::Subreddit, String] subreddit The subreddit to
        #   query.
        # @param [String] after Return results after the given
        #   fullname.
        # @param [String] before Return results before the given
        #   fullname.
        # @param [Integer] count The number of items already seen
        #   in the listing.
        # @param [1..100] limit The maximum number of things to
        #   return.
        # @param [:hour, :day, :week, :month, :year, :all] period The
        #   time period to consider when sorting.
        # @return [Redd::Object::Listing] A listing of submissions or comments.
        #
        # @note The option :t only applies to the top and controversial sorts.
        def get_listing(
          type, subreddit = nil, after: nil, before: nil, count: 0, limit: 25,
          period: :all
        )
          name = get_property(subreddit, :display_name) if subreddit

          params = {count: count, limit: limit, t: period}
          params[:after] = after if after
          params[:before] = before if before

          path = "/#{type}.json"
          path = path.prepend("/r/#{name}") if name

          request_object :get, path, params
        end
      end
    end
  end
end