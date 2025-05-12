# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable::Transformers::Redactor do
  subject(:transformer) { described_class }

  describe "#call" do
    it "answers redacted value" do
      expect(transformer.call("test")).to eq(%("[REDACTED]"))
    end

    it "answers nil when nil" do
      expect(transformer.call(nil)).to be(nil)
    end
  end
end
