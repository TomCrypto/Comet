module Comet
  module DSL
    class Software
      include Comet::DSL::Helpers
      alias inject instance_exec

      def source(language:, **kwargs, &block)
        source = Source.create(language: language, **kwargs, &block)
        raise 'native source only allowed in hardware block' if source.native?
        @sources.push source
      end

      def initialize(name, depends:, &block)
        @name = name
        @depends = depends
        @sources = []

        instance_exec(&block) if block_given?
      end

      def to_s
        "software #{@name}"
      end

      attr_accessor :depends
      attr_reader :sources

      def hardware_for(device)
        @depends.flat_map do |dependent|
          dependent.hardware_for device
        end.uniq
      end

      def validate!
        raise "#{@name} has no source directives" if sources.empty?

        depends.each(&:validate!)
        sources.each(&:validate!)
      end
    end
  end
end
