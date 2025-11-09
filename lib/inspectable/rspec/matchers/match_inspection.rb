# frozen_string_literal: true

RSpec::Matchers.define :match_inspection do |by: {}, **|
  match do |actual|
    defaults = {prefix: "@", delimiter: "=", separator: ", "}
    @prefix, @delimiter, @separator = defaults.merge!(by).values_at(*defaults.keys)
    @content = expected.map { |key, value| "#{@prefix}#{key}#{@delimiter}#{value}" }
                       .join @separator

    actual.match?(/#{@content}/)
  end

  failure_message do |actual|
    using = "using prefix: #{@prefix.inspect}, " \
            "delimiter: #{@delimiter.inspect}, and " \
            "separator: #{@separator.inspect}"

    <<~MESSAGE
      expected (#{using}):

      #{actual.inspect.gsub @separator, "#{@separator}\n"}

      to match:

      #{@content.gsub @separator, "#{@separator}\n"}
    MESSAGE
  end
end
