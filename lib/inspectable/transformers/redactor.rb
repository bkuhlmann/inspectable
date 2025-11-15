# frozen_string_literal: true

module Inspectable
  module Transformers
    # Redacts sensitive information.
    module Redactor
      module_function

      def call(value) = ("[REDACTED]".inspect if value)
    end
  end
end
