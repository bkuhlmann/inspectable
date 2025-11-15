# frozen_string_literal: true

module Inspectable
  module Transformers
    # Answers object's type.
    module Typer
      module_function

      def call(value) = value.class.name
    end
  end
end
