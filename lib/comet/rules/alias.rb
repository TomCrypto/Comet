module Comet
  module Rules
    class Alias
      def initialize(name, dependencies)
        @name = name
        @dependencies = dependencies
      end

      def target
        @name
      end

      def contents
        [
          ".PHONY: #{target}",
          "#{target}: #{@dependencies.map(&:target).uniq.join ' '}"
        ]
      end

      def rules
        []
      end

      def commands
        {}
      end
    end
  end
end
