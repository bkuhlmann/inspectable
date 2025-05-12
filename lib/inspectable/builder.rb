# frozen_string_literal: true

module Inspectable
  # Provides custom object inspection behavior.
  class Builder < Module
    def initialize *excludes, registry: Inspectable, **transformers
      super()
      @excludes = excludes.map { :"@#{it}" }
      @transformers = resolve transformers, registry

      validate
      define_inspect
      freeze
    end

    private

    attr_reader :excludes, :transformers

    def validate
      return unless excludes.empty? && transformers.empty?

      fail ArgumentError, "Excludes or transformers are required."
    end

    def define_inspect body_builder: method(:build_body)
      define_method :inspect do
        format %(#<%<class>s:%<id>#018x #{body_builder.call(self).chomp ", "}>),
               class: self.class,
               id: object_id << 1
      end
    end

    def build_body instance
      exclude_and_transform(instance).reduce(+"") do |body, (variable, value)|
        body << "#{variable}=#{value}, "
      end
    end

    def exclude_and_transform instance
      (instance.instance_variables - excludes).each.with_object({}) do |variable, attributes|
        value = instance.instance_variable_get variable
        transform = transformers[variable].call(value) if transformers.key? variable

        attributes[variable] = (transform || value.inspect)
      end
    end

    def resolve transformers, registry
      transformers.each.with_object({}) do |(key, object), collection|
        value = case object
                  when Proc then object
                  when Symbol then registry.transformers[object]
                  else fail TypeError, "Invalid transformer: #{object.inspect}. Use Proc or Symbol."
                end

        collection[:"@#{key}"] = value
      end
    end
  end
end
