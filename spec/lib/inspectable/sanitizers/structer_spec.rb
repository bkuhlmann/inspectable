# frozen_string_literal: true

require "spec_helper"
require SPEC_ROOT.join("support/fixtures/test_struct")

RSpec.describe Inspectable::Sanitizers::Structer do
  subject(:sanitizer) { described_class.new }

  describe "#initialize" do
    it "is frozen" do
      expect(sanitizer.frozen?).to be(true)
    end
  end

  describe "#call" do
    let(:instance) { Struct.new(:name, :label).new(name: "test", label: "Test") }

    it "answers anonymous instance with excluded variables" do
      expect(sanitizer.call(instance, :label)).to eq(%(#<struct name="test">))
    end

    it "answers anonymous instance with transformed values" do
      expect(sanitizer.call(instance, label: -> value { value.upcase.inspect })).to eq(
        %(#<struct name="test", label="TEST">)
      )
    end

    it "answers named instance with excluded and transformed variables" do
      instance = TestStruct[name: "test", label: "Test"]
      string = sanitizer.call(instance, :name, label: -> value { value.upcase.inspect })

      expect(string).to eq(%(#<struct TestStruct label="TEST">))
    end
  end
end
