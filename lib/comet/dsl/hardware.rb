module Comet
  module DSL
    class Hardware
      include Comet::DSL::Helpers
      alias inject instance_exec

      def source(language:, **kwargs, &block)
        @sources.push Source.create(language: language, **kwargs, &block)
      end

      def linker(*args, **kwargs, &block)
        raise 'linker section redefined' unless @linker_.nil?
        @linker_ = Linker.new(*args, **kwargs, &block)
      end

      def import(name, path: nil)
        @libraries.add Library.new(name, path: path)
      end

      def initialize(name, targets:, &block)
        @name = name
        @targets = targets
        @sources = []
        @linker_ = nil
        @libraries = Set[]

        instance_exec(&block) if block_given?
      end

      def to_s
        "hardware #{@name} for #{@targets}"
      end

      attr_reader :targets
      attr_reader :sources
      attr_reader :linker_

      def libraries
        @libraries.to_a
      end

      def hardware_for(device)
        device == targets ? self : []
      end

      def linker?
        !@linker_.nil?
      end

      def validate!
        sources.each(&:validate!)
        @linker.validate! unless @linker.nil?
      end
    end
  end
end
