module Comet
  module Rules
    class Build
      def initialize(firmware, device)
        @firmware = firmware
        @device = device
      end

      def target
        @target ||= Comet::Makefile.fingerprint Hash[
          dependencies: Set[rules.map(&:target).uniq]
        ], extension: :phony
      end

      def contents
        contents = [
          ".PHONY: #{target}",
          "#{target}: #{rules.map(&:target).uniq.join ' '}"
        ]

        if fw_target.elf?
          contents.push "\t$(COMET_CP) #{link.target} #{fw_target.elf_output.path}"
        end

        if fw_target.bin?
          contents.push "\t$(COMET_CP) #{bin.target} #{fw_target.bin_output.path}"
        end

        if fw_target.hex?
          contents.push "\t$(COMET_CP) #{hex.target} #{fw_target.hex_output.path}"
        end

        if fw_target.map?
          contents.push "\t$(COMET_CP) #{link.map_file} #{fw_target.map_output.path}"
        end

        contents
      end

      def rules
        @rules ||= [link, bin, hex].compact
      end

      def commands
        { COMET_CP: 'cp' }
      end

      private

      def fw_target
        @firmware.target_for @device
      end

      def bin
        ObjCopy.new linker, link, 'binary', 'bin' if fw_target.bin?
      end

      def hex
        ObjCopy.new linker, link, 'ihex', 'hex' if fw_target.hex?
      end

      def link
        @link ||= Link.new linker, codegen, libraries, native_sources
      end

      def linker
        @firmware.hardware_for(@device).detect(&:linker?).linker_
      end

      def native_sources
        @firmware.hardware_for(@device).flat_map do |hardware|
          hardware.sources.select(&:native?).flat_map(&:files)
        end
      end

      def libraries
        @firmware.hardware_for(@device).flat_map(&:libraries).uniq(&:name)
      end

      def codegen
        @codegen ||= Codegen.new linker, merge
      end

      def merge
        @merge ||= Merge.new compile
      end

      def compile
        @compile ||= @firmware.imports.flat_map do |software|
          compile_software software
        end
      end

      def compile_software(software)
        software.depends.flat_map do |depends|
          if depends.is_a? Comet::DSL::Software
            compile_software depends
          else
            compile_hardware depends
          end
        end + software.sources.reject(&:native?).flat_map do |source|
          source.files.map do |file|
            Compile.new source, file, linker
          end
        end
      end

      def compile_hardware(hardware)
        return [] unless hardware.targets == @device
        hardware.sources.reject(&:native?).flat_map do |source|
          source.files.map do |file|
            Compile.new source, file, linker
          end
        end
      end
    end
  end
end
