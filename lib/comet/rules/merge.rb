module Comet
  module Rules
    class Merge
      def initialize(dependencies)
        @dependencies = dependencies
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          command: llvm_link,
          dependencies: Set[@dependencies.map(&:target).uniq]
        ], extension: :ll
      end

      def contents
        [
          "#{target}: #{@dependencies.map(&:target).uniq.join ' '} | #{Comet::TMPDIR}",
          "\t#{llvm_link.join ' '} -o $@ $^"
        ]
      end

      def rules
        @dependencies
      end

      def commands
        { COMET_LINK: 'llvm-link' }
      end

      private

      def llvm_link
        ['$(COMET_LINK)', '-S']
      end
    end
  end
end
