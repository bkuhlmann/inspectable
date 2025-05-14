# frozen_string_literal: true

require "inspectable/builder"
require "inspectable/registry"
require "inspectable/sanitizers/classer"
require "inspectable/sanitizers/dater"
require "inspectable/transformers/classifier"
require "inspectable/transformers/redactor"

# Main namespace.
module Inspectable
  extend Registry

  INSPECTOR = -> value { value.inspect }

  def self.[](*, **) = Builder.new(*, **)
end
