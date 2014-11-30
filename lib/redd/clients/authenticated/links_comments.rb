module Redd
  module Clients
    class Authenticated
      # Methods to deal with comments and links
      module LinksComments
        # Submit a link or a text post to a subreddit.
        #
        # @param [String] title The title of the submission.
        # @param [String] text The content of the post.
        # @param [String] url The url of the post.
        # @param [Redd::Object::Submission, String] subreddit The subreddit
        #   to submit to.
        # @param [String] captcha A possible captcha result to send if one
        #   is required.
        # @param [String] iden The identifier for the captcha if one
        #   is required.
        # @param [Boolean] resubmit Whether to post a link
        #   to a subreddit despite it having been posted there before.
        # @param [Boolean] sendreplies Whether or not to send
        #   comments and replies to the inbox.
        def submit(
          title:, subreddit:, text: nil, url: nil, captcha: nil, iden: nil,
          resubmit: false, sendreplies: true
          )

          params = {
            api_type: "json", extension: "json", title: title,
            resubmit: resubmit, sendreplies: sendreplies
            }

          params[:sr] = get_property(subreddit, :display_name)

          if url
            params[:kind] = "link"
            params[:url] = url
          elsif text
            params[:kind] = "self"
            params[:text] = text
          else
            fail "Enter either a text or a url!"
          end

          params.merge(captcha: captcha, iden: iden) if captcha
          params.merge(kwargs)

          post "/api/submit", params
        end

        # Add a comment to a link, reply to a comment or reply to a message.
        # Bit of an all-purpose method, this one.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment,
        #   Redd::Object::PrivateMessage, String] thing A thing to add a
        #   comment to.
        # @param [String] text The text to comment.
        def add_comment(thing, text)
          fullname = get_property(thing, :fullname)
          post "/api/comment", api_type: "json", text: text, thing_id: fullname
        end
        alias_method :reply, :add_comment

        # Delete a thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String]
        #   thing A thing to delete.
        def delete(thing)
          fullname = get_property(thing, :fullname)
          post "/api/del", id: fullname
        end

        # Edit a thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A thing to delete.
        # @param [String] text The new text.
        def edit(thing, text)
          fullname = get_property(thing, :fullname)
          post(
            "/api/editusertext",
            api_type: "json",
            thing_id: fullname,
            text: text
            )
        end

        # Hide a link from the logged-in user.
        # @param [Redd::Object::Submission, String] thing A link to hide.
        def hide(thing)
          fullname = get_property(thing, :fullname)
          post "/api/hide", id: fullname
        end

        # Unhide a previously hidden link.
        # @param [Redd::Object::Submission, String] thing A link to show.
        def unhide(thing)
          fullname = get_property(thing, :fullname)
          post "/api/unhide", id: fullname
        end

        # Mark a link as "NSFW" (Not Suitable For Work)
        # @param [Redd::Object::Submission, String] thing A link to mark.
        def mark_as_nsfw(thing)
          fullname = get_property(thing, :fullname)
          post "/api/marknsfw", id: fullname
        end

        # Remove the NSFW label from the link.
        # @param [Redd::Object::Submission, String] thing A link to mark.
        def unmark_as_nsfw(thing)
          fullname = get_property(thing, :fullname)
          post "/api/unmarknsfw", id: fullname
        end
        alias_method :mark_as_safe, :unmark_as_nsfw

        # Report the link or comment to the subreddit moderators.
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link to report.
        def report(thing)
          fullname = get_property(thing, :fullname)
          post "/api/report", id: fullname
        end

        # Save a link or comment (if gilded) to the user's account.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link to save.
        # @param category [String] A category to save to (if gilded).
        def save(thing, category: nil)
          fullname = get_property(thing, :fullname)
          params = {id: fullname}
          params[:category] = category if category
          post "/api/save", params
        end

        # Remove the link or comment from the user's saved links.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link to unsave.
        def unsave(thing)
          fullname = get_property(thing, :fullname)
          post "/api/unsave", id: fullname
        end

        # Upvote the thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link or comment to upvote.
        # @see #vote
        def upvote(thing)
          vote(thing, 1)
        end

        # Downvote the thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link or comment to downvote.
        # @see #vote
        def downvote(thing)
          vote(thing, -1)
        end

        # Clear the user's vote on the thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link or comment to remove the vote on.
        # @see #vote
        def unvote(thing)
          vote(thing, 0)
        end
        alias_method :clear_vote, :unvote

        private

        # Set a vote on the thing.
        #
        # @param [Redd::Object::Submission, Redd::Object::Comment, String] thing
        #   A link or comment to set a vote on.
        # @note Votes must be cast by humans only! Your script can proxy a
        #   user's actions, but it cannot decide what to vote.
        def vote(thing, direction)
          fullname = get_property(thing, :fullname)
          post "/api/vote", id: fullname, dir: direction
        end
      end
    end
  end
end