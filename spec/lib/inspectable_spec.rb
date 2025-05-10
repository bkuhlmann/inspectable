# frozen_string_literal: true

require "spec_helper"

RSpec.describe Inspectable do
  describe ".[]" do
    let :implementation do
      Class.new do
        include Inspectable[:verbose, token: :redact]

        def initialize token: :redact, uri: "https://demo.io", verbose: "To be ignored."
          @token = token
          @uri = uri
          @verbose = verbose
        end
      end
    end

    it "exludes and transforms" do
      expect(implementation.new.inspect).to match(
        %r(#<#<Class:.+{18}\s@token="\[REDACTED\]", @uri="https://demo.io">)
      )
    end
  end
end
