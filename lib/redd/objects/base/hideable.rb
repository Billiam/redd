module Redd
  module Objects
    class Base
      # An item that can be hidden.
      module Hideable
        # Hide the item.
        def hide
          client.hide(self)
        end

        # Unhide the item.
        def unhide
          client.unhide(self)
        end
        alias_method :show, :unhide
      end
    end
  end
end
