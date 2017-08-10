module Comet
  module Rules
    class Compile
      def initialize(source, file, linker)
        @source = source
        @file = file
        @linker = linker
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          file: @file,
          triple: @linker.triple,
          isa: @linker.isa,
          cpu: @linker.cpu,
          language: @source.language,
          flags: Set[formatted_flags],
          headers: formatted_headers,
          dependencies: Set[dependencies]
        ], extension: :ll
      end

      def contents
        [
          "#{target}: #{@file} #{dependencies.join ' '} | #{Comet::TMPDIR}",
          "\t#{clang_compile} #{formatted_flags.join ' '} -o $@ -c $<"
        ]
      end

      def rules
        []
      end

      def commands
        { COMET_CC: 'clang' }
      end

      private

      def formatted_flags
        @formatted_flags ||= @source.options.format
      end

      def dependencies
        @dependencies ||= find_dependencies
      end

      def find_dependencies
        Comet::DSL::IncludeWalker.includes_for(@file, @source.headers)
      end

      def clang_compile
        [
          '$(COMET_CC)',
          '-x',
          @source.language == :c ? 'c' : 'c++',
          "--target=#{@linker.triple}",
          "-march=#{@linker.isa}",
          "-mcpu=#{@linker.cpu}",
          '-S',
          '-flto',
          *formatted_headers
        ].join ' '
      end

      def formatted_headers
        @source.headers.map do |header|
          "-I#{header}"
        end.join ' '
      end
    end
  end
end
