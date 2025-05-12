# frozen_string_literal: true

module Inspectable
  module Transformers
    # Redacts sensitive information.
    Redactor = -> value { "[REDACTED]".inspect if value }
  end
end
