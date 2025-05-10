# frozen_string_literal: true

require "inspectable/builder"
require "inspectable/registry"
require "inspectable/transformers/classifier"
require "inspectable/transformers/redactor"

# Main namespace.
module Inspectable
  extend Registry

  def self.[](*, **) = Builder.new(*, **)
end
