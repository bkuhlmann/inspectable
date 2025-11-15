# frozen_string_literal: true

module Inspectable
  module Sanitizers
    # Excludes and transforms data members.
    class Data
      def initialize pattern: "#<data%<class>s %<body>s>", inspector: INSPECTOR
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
          value = instance.public_send member
          body << "#{member}=#{transformers.fetch(member, inspector).call value}, "
        end
      end
    end
  end
end
