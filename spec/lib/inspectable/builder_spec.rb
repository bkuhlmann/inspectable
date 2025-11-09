# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Builder do
  describe "#initalize" do
    it "answers original string (i.e. delegates to super)" do
      expectation = proc { described_class.new }
      expect(&expectation).to raise_error(ArgumentError, "Excludes or transformers are required.")
    end

    it "is frozen" do
      expect(described_class.new(:test).frozen?).to be(true)
    end
  end

  describe "#included" do
    let :with_native_inspection do
      proc do
        Class.new do
          include Inspectable::Builder.new(:name)

          def initialize name = "test"
            @name = name
          end

          private

          def instance_variables_to_inspect = [:@name]
        end
      end
    end

    it "fails when included in a module" do
      expectation = proc { Module.new.include described_class.new(:test) }
      expect(&expectation).to raise_error(TypeError, "Use Class, Struct, or Data.")
    end

    it "fails when defining instance variables to inspect" do
      expect(&with_native_inspection).to raise_error(
        NoMethodError,
        "Defining method :instance_variables_to_inspect is disabled."
      )
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
          include Inspectable::Builder.new(token: :redact, contract: :type)

          def initialize token: "secret", contract: Object.new
            @token = token
            @contract = contract
          end
        end
      end

      it "answers transformed values" do
        expect(implementation.new.inspect).to match(
          /#<#<Class:.+{18}\s@token="\[REDACTED\]", @contract=Object>/
        )
      end
    end

    context "with custom transformers" do
      let :implementation do
        Class.new do
          include Inspectable::Builder.new(
            name: -> value { "t-#{value}".inspect },
            label: -> value { value.upcase.inspect }
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

    context "with struct" do
      let :implementation do
        Struct.new :name, :label do
          include Inspectable::Builder.new(:name, label: :redact)
        end
      end

      it "answers transformed values" do
        expect(implementation[name: "test", label: "Test"].inspect).to eq(
          %(#<struct label="[REDACTED]">)
        )
      end
    end

    context "with data" do
      let :implementation do
        implementation = described_class.new :name, label: :redact
        Data.define(:name, :label) { include implementation }
      end

      it "answers transformed values" do
        expect(implementation[name: "test", label: "Test"].inspect).to eq(
          %(#<data label="[REDACTED]">)
        )
      end
    end

    context "with unknown type" do
      let :implementation do
        Struct.new :name do
          def class = Comparable

          include Inspectable::Builder.new(:name)
        end
      end

      it "fails with type error" do
        expectation = proc { implementation[name: "test"].inspect }
        expect(&expectation).to raise_error(TypeError, "Unknown type. Use Class, Struct, or Data.")
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
