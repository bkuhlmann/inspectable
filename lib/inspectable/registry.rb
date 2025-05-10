# frozen_string_literal: true

module Inspectable
  # Provides global regsitry for further customization.
  module Registry
    def self.extended descendant
      descendant.add_transformer(:class, Inspectable::Transformers::Classifier)
                .add_transformer :redact, Inspectable::Transformers::Redactor
    end

    def add_transformer key, function
      transformers[key.to_sym] = function
      self
    end

    def transformers = @transformers ||= {}
  end
end
