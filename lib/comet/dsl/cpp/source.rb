module Comet
  module DSL
    module CPP
      class Source
        include Comet::DSL::Helpers
        alias inject instance_exec

        def import(pattern)
          @imports.push pattern
        end

        def option(*args, **kwargs)
          @options.add('', *args, **kwargs)
        end

        def define(*args, **kwargs)
          @options.add('D', *args, **kwargs)
        end

        def initialize(headers:, &block)
          @headers = headers
          @imports = []
          @options = Comet::DSL::Options.new

          instance_exec(&block) if block_given?
        end

        def to_s
          'C++ source'
        end

        attr_reader :headers
        attr_reader :imports
        attr_reader :options

        def language
          :cpp
        end

        def native?
          false
        end

        def files
          @imports.flat_map do |pattern|
            Dir.glob pattern
          end.uniq
        end

        def validate!
          raise "#{self} references no source files" if @imports.empty?
          @options.validate!
        end
      end
    end
  end
end
