# frozen_string_literal: true

require "inspectable/builder"
require "inspectable/registry"
require "inspectable/sanitizers/data"
require "inspectable/sanitizers/struct"
require "inspectable/sanitizers/type"
require "inspectable/transformers/redactor"
require "inspectable/transformers/typer"

# Main namespace.
module Inspectable
  extend Registry

  INSPECTOR = -> value { value.inspect }

  CONTAINER = {
    registry: self,
    class: Sanitizers::Type.new,
    data: Sanitizers::Data.new,
    struct: Sanitizers::Struct.new
  }.freeze

  def self.[](*, **) = Builder.new(*, **)
end
