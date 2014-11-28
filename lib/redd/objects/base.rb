require "memoist"

module Redd
  module Objects
    # A container for various models with attributes and a client.
    class Base
      extend Memoist

      # @!attribute [r] attributes
      # @return [Hash] A list of attributes returned by reddit for this
      #   object.
      attr_reader :attributes
      alias_method :to_h, :attributes

      class << self
        # Define and memoize the method that returns a key from the attributes
        # hash.
        #
        # @param [Symbol, String] name The attribute to construct a method out
        #   of.
        def attribute(name)
          define_attribute_method(name)
          define_predicate_method(name)
        end

        # Create a new method with the given name that accesses the @attributes.
        def define_attribute_method(method)
          define_method(method) { @attributes[method] }
          memoize method
        end

        # Create a new method with the given name that accesses the @attributes.
        # @return [Boolean]
        def define_predicate_method(method)
          define_method(:"#{method}?") { !!@attributes[method] }
          memoize :"#{method}?"
        end
      end

      # @param [Hash] attributes
      def initialize(attributes)
        @attributes = attributes[:data]
        @attributes[:kind] = attributes[:kind]
      end

      # @param method [#to_sym] An attribute of the class
      # @return The attribute requested
      def [](method)
        send(method.to_sym)
      rescue NoMethodError
        nil
      end

      # Update attributes for the current object.
      # @param new_attributes [Hash] The new attributes.
      # @return The new attributes.
      def update(new_attributes)
        @attributes.merge!(new_attributes)
      end
    end
  end
end
