require_relative "../../objects/thing"
require_relative "../../objects/comment"

module Redd
  module Clients
    class Unauthenticated
      # Non-API methods that make life easier.
      module Utilities
        private

        # @param [String] kind A kind in the format /t[1-5]/.
        # @return [Redd::Objects::Thing, Redd::Objects::Listing] The appropriate
        #   object for a given kind or Redd::Objects::Thing if nothing is found.
        def object_from_kind(kind)
          objects = {
            # "Listing"  => Redd::Objects::Listing,
            # "wikipage" =>  Redd::Objects::WikiPage,
            # "more"     => Redd::Objects::MoreComments,
            "t1"       => Redd::Objects::Comment
            # "t2"       => Redd::Objects::User,
            # "t3"       => Redd::Objects::Submission,
            # "t4"       => Redd::Objects::PrivateMessage,
            # "t5"       => Redd::Objects::Subreddit
          }

          objects.fetch(kind, Redd::Thing)
        end

        # Create an object instance with the correct attributes when given a
        # body.
        #
        # @param [String] body A JSON hash.
        # @return [Redd::Objects::Thing, Redd::Objects::Listing]
        # rubocop:disable Metrics/MethodLength
        def object_from_body(body)
          return nil unless body.is_a?(Hash) && body.key?(:kind)
          object = object_from_kind(body[:kind])

          if object == Redd::Object::Listing
            object.new(
              children: objects_from_listing(body),
              before: body[:data][:before],
              after: body[:data][:after]
            )
          else
            object.new(body)
          end
        end

        def objects_from_listing(listing)
          listing[:data][:children].map do |child|
            object_from_body(child)
          end
        end

        def request_object(response)
          object_from_body(response.body)
        end
      end
    end
  end
end
