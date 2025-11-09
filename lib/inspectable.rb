# frozen_string_literal: true

require "inspectable/builder"
require "inspectable/registry"
require "inspectable/sanitizers/classer"
require "inspectable/sanitizers/dater"
require "inspectable/sanitizers/structer"
require "inspectable/transformers/redactor"
require "inspectable/transformers/typer"

# Main namespace.
module Inspectable
  extend Registry

  INSPECTOR = -> value { value.inspect }

  CONTAINER = {
    registry: self,
    class: Sanitizers::Classer.new,
    data: Sanitizers::Dater.new,
    struct: Sanitizers::Structer.new
  }.freeze

  def self.[](*, **) = Builder.new(*, **)
end
