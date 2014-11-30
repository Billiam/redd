module Redd
  module Objects
    class Base
      module Editable
        # Edit the item.
        def edit(text)
          client.edit(self, text)
        end

        # Delete the item.
        def delete
          client.delete(self)
        end
      end
    end
  end
end
