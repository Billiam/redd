require_relative "../../objects/base"
require_relative "../../objects/listing"
require_relative "../../objects/comment"
require_relative "../../objects/user"
require_relative "../../objects/submission"
require_relative "../../objects/private_message"
require_relative "../../objects/subreddit"
require_relative "../../objects/wiki_page"
require_relative "../../objects/more_comments"

module Redd
  module Clients
    class Unauthenticated
      # Non-API methods that make life easier.
      module Utilities
        private

        def get_property(object, property)
          case object
          when String
            object
          when Objects::Base
            object.send(property)
          else
            object.to_s
          end
        end

        # @param [String] kind A kind in the format /t[1-5]/.
        # @return [Redd::Objects::Thing, Redd::Objects::Listing] The appropriate
        #   object for a given kind or Redd::Objects::Thing if nothing is found.
        def object_from_kind(kind)
          objects = {
            "Listing"  => Objects::Listing,
            "wikipage" => Objects::WikiPage,
            "more"     => Objects::MoreComments,
            "t1"       => Objects::Comment,
            "t2"       => Objects::User,
            "t3"       => Objects::Submission,
            "t4"       => Objects::PrivateMessage,
            "t5"       => Objects::Subreddit
          }

          objects.fetch(kind, Objects::Base)
        end

        def objects_from_listing(listing)
          listing[:data][:children].map do |child|
            object_from_body(child)
          end
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

          if object == Redd::Objects::Listing
            object.new(
              objects_from_listing(body),
              before: body[:data][:before],
              after: body[:data][:after]
            )
          else
            properties = body[:data]
            properties[:kind] = body[:kind]
            object.new(self, property)
          end
        end

        def request_object(meth, path, params = nil)
          body = request(meth, path, params).body
          object_from_body(body)
        end
      end
    end
  end
end
