# frozen_string_literal: true

module Inspectable
  module Transformers
    # Answers object's type.
    Typer = -> value { value.class.name }
  end
end
