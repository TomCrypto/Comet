module Comet
  module DSL
    class ElfOutput
      def initialize(path)
        @path = path
      end

      def to_s
        'elf output'
      end

      attr_reader :path

      def validate!
        raise "#{self} path is invalid" if @path.strip.empty?
      end
    end
  end
end
