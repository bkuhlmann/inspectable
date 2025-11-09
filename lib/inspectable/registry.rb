# frozen_string_literal: true

module Inspectable
  # Provides global regsitry for further customization.
  module Registry
    def self.extended descendant
      descendant.add_transformer(:redact, Inspectable::Transformers::Redactor)
                .add_transformer(:type, Inspectable::Transformers::Typer)
    end

    def add_transformer key, function
      transformers[key.to_sym] = function
      self
    end

    def transformers = @transformers ||= {}
  end
end
