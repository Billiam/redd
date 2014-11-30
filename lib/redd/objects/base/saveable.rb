module Redd
  module Objects
    class Base
      module Saveable
        # Save the item.
        def save(category: nil)
          client.save(self, category)
        end

        # Unsave the item.
        def unsave
          client.unsave(self)
        end
      end
    end
  end
end
