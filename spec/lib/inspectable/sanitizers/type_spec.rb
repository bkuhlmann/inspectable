# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Sanitizers::Type do
  subject(:sanitizer) { described_class.new }

  describe "#initialize" do
    it "is frozen" do
      expect(sanitizer.frozen?).to be(true)
    end
  end

  describe "#call" do
    let(:instance) { implementation.new }

    let :implementation do
      Class.new do
        def initialize name: "test", label: "Test"
          @name = name
          @label = label
        end
      end
    end

    it "answers excluded variables" do
      expect(sanitizer.call(instance, :label)).to match(/#<#<Class:.+{18}\s@name="test">/)
    end

    it "answers transformed values" do
      expect(sanitizer.call(instance, label: -> value { value.upcase.inspect })).to match(
        /#<#<Class:.+{18}\s@name="test", @label="TEST">/
      )
    end
  end
end
