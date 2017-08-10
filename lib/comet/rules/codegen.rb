module Comet
  module Rules
    class Codegen
      def initialize(linker, bitcode)
        @linker = linker
        @bitcode = bitcode
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          command: llc_command,
          opt: @linker.opt
        ], extension: :s
      end

      def contents
        [
          "#{target}: #{@bitcode.target} | #{Comet::TMPDIR}",
          "\t#{llvm_codegen} -o $@ $<"
        ]
      end

      def rules
        @rules ||= [@bitcode]
      end

      def commands
        { COMET_OPT: 'llc' }
      end

      private

      def llvm_codegen
        llc_command.join ' '
      end

      def llc_command
        ['$(COMET_OPT)', '-filetype=asm', "-O#{@linker.opt}"]
      end
    end
  end
end
