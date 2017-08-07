module Comet
  module DSL
    class MapOutput
      def initialize(path)
        @path = path
      end

      def to_s
        'map output'
      end

      attr_reader :path

      def validate!
        raise "#{self} path is invalid" if @path.strip.empty?
      end
    end
  end
end
