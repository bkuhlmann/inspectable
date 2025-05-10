# frozen_string_literal: true

module Inspectable
  module Transformers
    # Redacts sensitive information.
    Redactor = -> value { "[REDACTED]" if value }
  end
end
