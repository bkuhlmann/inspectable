# frozen_string_literal: true

module Inspectable
  module Sanitizers
    # Excludes and transforms object types.
    class Type
      def initialize pattern: "#<%<class>s:%<id>#018x %<body>s>", inspector: INSPECTOR
        @pattern = pattern
        @inspector = inspector
        freeze
      end

      def call instance, *excludes, **transformers
        variables = instance.instance_variables - excludes.map { :"@#{it}" }

        format pattern,
               class: instance.class,
               id: object_id << 1,
               body: exclude_and_transform(instance, variables, transformers).chomp(", ")
      end

      private

      attr_reader :pattern, :inspector

      def exclude_and_transform instance, variables, transformers
        variables.reduce(+"") do |body, variable|
          key = variable.to_s.delete_prefix("@").to_sym
          value = instance.instance_variable_get variable

          body << "#{variable}=#{transformers.fetch(key, inspector).call value}, "
        end
      end
    end
  end
end
