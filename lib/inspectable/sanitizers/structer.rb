# frozen_string_literal: true

module Inspectable
  module Sanitizers
    # Excludes and transforms struct members.
    class Structer
      def initialize pattern: "#<struct%<class>s %<body>s>", inspector: Inspectable::INSPECTOR
        @pattern = pattern
        @inspector = inspector
        freeze
      end

      def call instance, *excludes, **transformers
        format pattern,
               class: instance.class.name.then { " #{it}" if it },
               body: exclude_and_transform(instance, excludes, transformers).chomp(", ")
      end

      private

      attr_reader :pattern, :inspector

      def exclude_and_transform instance, excludes, transformers
        (instance.members - excludes).reduce(+"") do |body, member|
          body << "#{member}=#{transformers.fetch(member, inspector).call instance[member]}, "
        end
      end
    end
  end
end
