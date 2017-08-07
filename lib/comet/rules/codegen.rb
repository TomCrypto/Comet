module Comet
  module Rules
    class Codegen
      def initialize(linker, bitcode)
        @linker = linker
        @bitcode = bitcode
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          command: clang_link_command,
          target: @bitcode.target,
          triple: @linker.triple,
          isa: @linker.isa,
          cpu: @linker.cpu,
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
        { COMET_OPT: 'clang' }
      end

      private

      def llvm_codegen
        [
          *clang_link_command,
          "--target=#{@linker.triple}",
          "-march=#{@linker.isa}",
          "-mcpu=#{@linker.cpu}"
        ].join ' '
      end

      def clang_link_command
        ['$(COMET_OPT)', '-S', "-O#{@linker.opt}"]
      end
    end
  end
end
