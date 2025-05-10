# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Transformers::Classifier do
  subject(:transformer) { described_class }

  describe "#call" do
    it "answers general object class" do
      expect(transformer.call(Object.new)).to eq("Object")
    end

    it "answers transformer specific class" do
      expect(transformer.call(transformer)).to eq("Proc")
    end
  end
end
