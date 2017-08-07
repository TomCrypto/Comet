module Comet
  module Rules
    class ObjCopy
      def initialize(linker, elf, format, extension)
        @linker = linker
        @elf = elf
        @format = format
        @extension = extension
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          triple: @linker.triple,
          format: @format,
          elf: @elf.target
        ], extension: @extension
      end

      def contents
        [
          "#{target}: #{@elf.target} | #{Comet::TMPDIR}",
          "\t#{objcopy}"
        ]
      end

      def rules
        [@elf]
      end

      def commands
        { COMET_OBJCOPY: 'objcopy' }
      end

      private

      def objcopy
        Comet::Makefile.select_command "#{@linker.triple}-$(COMET_OBJCOPY)", '$(COMET_OBJCOPY)', ['-O', @format, '$<', '$@']
      end
    end
  end
end
