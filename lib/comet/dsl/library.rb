module Comet
  module DSL
    class Library
      def initialize(name, path: nil)
        @name = name
        @path = path
      end

      def to_s
        "library #{@name}"
      end

      attr_reader :name
      attr_reader :path

      def validate!
        true
      end
    end
  end
end
