module Comet
  module DSL
    class Linker
      include Comet::DSL::Helpers
      alias inject instance_exec

      def script(script)
        @script = script
      end

      def option(*args, **kwargs)
        @options.add('', *args, **kwargs)
      end

      def initialize(triple, isa:, cpu:, opt:, &block)
        @triple = triple
        @isa = isa
        @cpu = cpu
        @options = Options.new
        @opt = opt
        @script = nil

        instance_exec(&block) if block_given?
      end

      def to_s
        "linker #{@triple}"
      end

      attr_reader :triple
      attr_reader :isa
      attr_reader :cpu
      attr_reader :options
      attr_reader :opt

      def script_
        @script
      end

      def validate!
        raise "#{self} triple is invalid" if @triple.strip.empty?
      end
    end
  end
end
