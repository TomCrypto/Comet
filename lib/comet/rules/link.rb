module Comet
  module Rules
    class Link
      def initialize(linker, dependency, libraries, native_sources)
        @linker = linker
        @dependency = dependency
        @libraries = libraries
        @native_sources = native_sources
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          dependency: @dependency.target,
          triple: @linker.triple,
          isa: @linker.isa,
          cpu: @linker.cpu,
          script: @linker.script_,
          libraries: formatted_libraries,
          native_sources: @native_sources,
          flags: formatted_flags
        ], extension: :elf
      end

      def map_file
        target.gsub(/.elf$/, '.map')
      end

      def contents
        [
          "#{target}: #{@dependency.target} #{@native_sources.join ' '} | #{Comet::TMPDIR}",
          "\t#{clang_link} #{formatted_script} #{formatted_flags.join ' '} -Wl,-Map=#{map_file} -o $@ $^ #{formatted_libraries}"
        ]
      end

      def rules
        [@dependency]
      end

      def commands
        { COMET_LD: 'clang' }
      end

      private

      def formatted_script
        return '' if @linker.script_.nil?
        "-T#{@linker.script_}"
      end

      def formatted_flags
        @formatted_flags ||= @linker.options.format
      end

      def clang_link
        [
          '$(COMET_LD)',
          "--target=#{@linker.triple}",
          "-march=#{@linker.isa}",
          "-mcpu=#{@linker.cpu}"
        ].join ' '
      end

      def formatted_libraries
        @libraries.flat_map do |library|
          if library.path.nil?
            "-l#{library.name}"
          else
            ["-L#{File.join library.path, library.name}"]
          end
        end.join ' '
      end
    end
  end
end
