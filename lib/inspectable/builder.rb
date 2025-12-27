# frozen_string_literal: true

module Inspectable
  # Provides custom object inspection behavior.
  class Builder < Module
    def initialize *excludes, container: CONTAINER, **transformers
      super()
      @excludes = excludes
      @container = container
      @transformers = resolve transformers

      validate
      define_inspect
      freeze
    end

    def included descendant
      descendant.define_singleton_method :method_added do |name|
        return super(name) unless name == :instance_variables_to_inspect

        fail NoMethodError, "Defining method :instance_variables_to_inspect is disabled."
      end

      case descendant
        when Class, Struct, Data then super
        else fail TypeError, "Use Class, Struct, or Data."
      end
    end

    private

    attr_reader :excludes, :container, :transformers

    def resolve transformers
      transformers.each.with_object({}) do |(variable, object), collection|
        collection[variable] = acquire object
      end
    end

    def acquire object
      case object
        when Proc then object
        when Symbol then container.fetch(:registry).transformers[object]
        else fail TypeError, "Invalid transformer: #{object.inspect}. Use Proc or Symbol."
      end
    end

    def validate
      return unless excludes.empty? && transformers.empty?

      fail ArgumentError, "Excludes or transformers are required."
    end

    def define_inspect renderer: method(:render)
      define_method :inspect do
        klass = self.class

        if klass < Struct then renderer.call self, :struct
        elsif klass < Data then renderer.call self, :data
        elsif klass.is_a? Class then renderer.call self, :class
        else renderer.call self, :unknown
        end
      end
    end

    def render instance, type
      container.fetch(type) { fail TypeError, "Unknown type. Use Class, Struct, or Data." }
               .then { |serializer| serializer.call(instance, *excludes, **transformers) }
    end
  end
end
