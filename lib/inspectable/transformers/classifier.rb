# frozen_string_literal: true

module Inspectable
  module Transformers
    # Answers value's class.
    Classifier = -> value { value.class.name }
  end
end
