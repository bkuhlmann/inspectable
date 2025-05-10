# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Builder do
  describe "#initalize" do
    it "answers original string (i.e. delegates to super)" do
      expectation = proc { described_class.new }
      expect(&expectation).to raise_error(ArgumentError, "Excludes or transformers are required.")
    end
  end

  describe "#inspect" do
    context "with excludes" do
      let :implementation do
        Class.new do
          include Inspectable::Builder.new(:label)

          def initialize name: "test", label: "Test"
            @name = name
            @label = label
          end
        end
      end

      it "answers string with specific instance variables removed" do
        expect(implementation.new.inspect).to match(/#<#<Class:.+{18}\s@name="test">/)
      end
    end

    context "with default transformers" do
      let :implementation do
        Class.new do
          include Inspectable::Builder.new(token: :redact, contract: :class)

          def initialize token: "secret", contract: Object.new
            @token = token
            @contract = contract
          end
        end
      end

      it "answers transformed values" do
        expect(implementation.new.inspect).to match(
          /#<#<Class:.+{18}\s@token="\[REDACTED\]", @contract="Object">/
        )
      end
    end

    context "with custom transformers" do
      let :implementation do
        Class.new do
          include Inspectable::Builder.new(
            name: -> value { "t-#{value}" },
            label: -> value { value.upcase }
          )

          def initialize name: "test", label: "Test"
            @name = name
            @label = label
          end
        end
      end

      it "answers transformed values" do
        expect(implementation.new.inspect).to match(
          /#<#<Class:.+{18}\s@name="t-test", @label="TEST">/
        )
      end
    end

    it "fails (type error) with invalid transformer" do
      expectation = proc { described_class.new name: "bogus" }

      expect(&expectation).to raise_error(
        TypeError,
        %(Invalid transformer: "bogus". Use Proc or Symbol.)
      )
    end
  end
end
