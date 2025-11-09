# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Transformers::Typer do
  subject(:transformer) { described_class }

  describe "#call" do
    it "answers module's class name" do
      expect(transformer.call(Module.new)).to eq("Module")
    end

    it "answers class' class name" do
      expect(transformer.call(Class.new)).to eq("Class")
    end

    it "answers object's class name" do
      expect(transformer.call(Object.new)).to eq("Object")
    end

    it "answers transformer's class name" do
      expect(transformer.call(transformer)).to eq("Proc")
    end
  end
end
