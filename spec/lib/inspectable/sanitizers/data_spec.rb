# frozen_string_literal: true

require "spec_helper"
require SPEC_ROOT.join("support/fixtures/test_data")

RSpec.describe Inspectable::Sanitizers::Data do
  subject(:sanitizer) { described_class.new }

  describe "#initialize" do
    it "is frozen" do
      expect(sanitizer.frozen?).to be(true)
    end
  end

  describe "#call" do
    let(:instance) { Data.define(:name, :label).new(name: "test", label: "Test") }

    it "answers anonymous instance with excluded variables" do
      expect(sanitizer.call(instance, :label)).to eq(%(#<data name="test">))
    end

    it "answers anonymous instance with transformed values" do
      expect(sanitizer.call(instance, label: -> value { value.upcase.inspect })).to eq(
        %(#<data name="test", label="TEST">)
      )
    end

    it "answers named instance with excluded and transformed variables" do
      instance = TestData[name: "test", label: "Test"]
      string = sanitizer.call(instance, :name, label: -> value { value.upcase.inspect })

      expect(string).to eq(%(#<data TestData label="TEST">))
    end

    it "fails when transformer is nil" do
      expectation = proc { sanitizer.call instance, name: nil }

      expect(&expectation).to raise_error(
        ArgumentError,
        "Invalid transformer registered for: name."
      )
    end
  end
end
