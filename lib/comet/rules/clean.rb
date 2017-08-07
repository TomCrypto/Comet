module Comet
  module Rules
    class Clean
      def initialize(folder)
        @folder = folder
      end

      def target
        'clean'
      end

      def contents
        [
          ".PHONY: #{target}",
          "#{target}:",
          "\t$(COMET_RM) -rf #{@folder}"
        ]
      end

      def rules
        []
      end

      def commands
        { COMET_RM: 'rm' }
      end
    end
  end
end
