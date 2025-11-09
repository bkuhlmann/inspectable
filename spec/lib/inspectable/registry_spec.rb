# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Registry do
  subject(:registry) { Class.new { extend Inspectable::Registry } }

  let :transformers do
    {
      redact: Inspectable::Transformers::Redactor,
      type: Inspectable::Transformers::Typer
    }
  end

  describe ".extended" do
    it "adds default transformers" do
      expect(registry.transformers).to eq(transformers)
    end
  end

  describe "#add_transformer" do
    let(:function) { -> value { value } }

    it "adds transformer (string key)" do
      registry.add_transformer "test", function
      expect(registry.transformers).to eq(transformers.merge(test: function))
    end

    it "adds transformer (symbol key)" do
      registry.add_transformer :test, function
      expect(registry.transformers).to eq(transformers.merge(test: function))
    end

    it "overrides existing transformer" do
      registry.add_transformer :redact, function

      expect(registry.transformers).to eq(
        redact: function,
        type: Inspectable::Transformers::Typer
      )
    end

    it "answers itself" do
      expect(registry.add_transformer(:test, function)).to eq(registry)
    end
  end

  describe "#transformers" do
    it "answers default transformers" do
      expect(registry.transformers).to eq(transformers)
    end
  end
end
