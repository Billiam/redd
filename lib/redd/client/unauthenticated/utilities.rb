require "redd/thing"
require "redd/object/listing"
require "redd/object/comment"
require "redd/object/more_comments"
require "redd/object/private_message"
require "redd/object/submission"
require "redd/object/subreddit"
require "redd/object/user"
require "redd/object/wiki_page"

module Redd
  module Client
    class Unauthenticated
      # Non-API methods that make life easier
      module Utilities
        def comment_stream(*args, &block)
          submission_stream(:comments, *args, &block)
        end

        def submission_stream(listing, subreddit = nil, params = {}, &block)
          loop do
            # Get the latest comments from the subreddit. By the way, this line
            #   is the one where the sleeping/rate-limiting happens.
            objects = get_listing(listing, subreddit, params)
            unless objects.empty?
              # Run the loop for each of the new comments accessed.
              # I should probably add it to a Set to avoid duplicates.
              objects.reverse_each { |object| block.call(object) }
              # Set the latest comment.
              params[:before] = objects.first.fullname
            end
          end
        end

        private

        def extract_attribute(object, attribute)
          case object
          when ::String
            object
          else
            object.send(attribute)
          end
        end

        def extract_fullname(object)
          extract_attribute(object, :fullname)
        end

        def extract_id(object)
          extract_attribute(object, :id)
        end

        # rubocop:disable Style/MethodLength, Style/CyclomaticComplexity
        def object_from_kind(kind)
          case kind
          when "Listing"
            Redd::Object::Listing
          when "more"
            Redd::Object::MoreComments
          when "t1"
            Redd::Object::Comment
          when "t2"
            Redd::Object::User
          when "t3"
            Redd::Object::Submission
          when "t4"
            Redd::Object::PrivateMessage
          when "t5"
            Redd::Object::Subreddit
          when "wikipage"
            Redd::Object::WikiPage
          else
            Redd::Thing
          end
        end
        # rubocop:enable Style/MethodLength, Style/CyclomaticComplexity

        def objects_from_listing(thing)
          thing[:data][:children].map do |child|
            object_from_body(child)
          end
        end

        def object_from_body(body)
          return nil unless body.is_a?(Hash) && body.key?(:kind)
          object = object_from_kind(body[:kind])

          if object == Redd::Object::Listing
            body[:data][:children] = objects_from_listing(body)
            object.new(body)
          else
            object.new(self, body)
          end
        end

        def comments_from_response(*args)
					body = request(*args).body[1]
          object_from_body(body)
        end

        def object_from_response(*args)
					body = request(*args).body
          object_from_body(body)
        end
      end
    end
  end
end
