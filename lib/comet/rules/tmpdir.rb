module Comet
  module Rules
    class TmpDir
      def target
        Comet::TMPDIR
      end

      def contents
        [
          ".PHONY: #{target}",
          "#{target}:",
          "\tif #{exists?} || #{valid?}; then #{create}; fi"
        ]
      end

      def rules
        []
      end

      def commands
        { COMET_LN: 'ln' }
      end

      private

      def exists?
        '[ ! -d "$@" ]'
      end

      def valid?
        "[ ! -d \"`readlink #{target}`\" ]"
      end

      def create
        '$(COMET_LN) -sf `mktemp -d` $@'
      end
    end
  end
end
