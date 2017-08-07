module Comet
  module DSL
    class Target
      include Comet::DSL::Helpers
      alias inject instance_exec

      def elf(path)
        @elf_output = ElfOutput.new(path)
      end

      def bin(path)
        @bin_output = BinOutput.new(path)
      end

      def hex(path)
        @hex_output = HexOutput.new(path)
      end

      def map(path)
        @map_output = MapOutput.new(path)
      end

      def initialize(device, &block)
        @elf_output = nil
        @bin_output = nil
        @hex_output = nil
        @map_output = nil
        @device = device

        instance_exec(&block) if block_given?
      end

      def to_s
        "target for #{@device}"
      end

      attr_reader :elf_output
      attr_reader :bin_output
      attr_reader :hex_output
      attr_reader :map_output

      def elf?
        !@elf_output.nil?
      end

      def bin?
        !@bin_output.nil?
      end

      def hex?
        !@hex_output.nil?
      end

      def map?
        !@map_output.nil?
      end

      def validate!
        has_outputs = [elf?, bin?, hex?, map?].any?
        raise "#{self} describes no outputs" unless has_outputs
      end
    end
  end
end
