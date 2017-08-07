module Comet
  module DSL
    class Options
      def initialize
        @options = {}
      end

      def to_s
        'options'
      end

      def add(prefix, *args, **kwargs)
        args.each do |key|
          set_option "#{prefix}#{key}"
        end

        kwargs.each do |key, value|
          set_option "#{prefix}#{key}", value
        end
      end

      def format(prefix: '-', separator: '=')
        @options.map do |key, value|
          next "#{prefix}#{key}" if value.nil?
          "#{prefix}#{key}#{separator}#{value}"
        end
      end

      def validate!
        true
      end

      private

      def set_option(key, value = nil)
        if value == :remove
          @options.delete key
        else
          @options[key] = value
        end
      end
    end
  end
end
