module Comet
  module DSL
    module Native
      class Source
        include Comet::DSL::Helpers
        alias inject instance_exec

        def import(pattern)
          @imports.push pattern
        end

        def initialize(**_, &block)
          @imports = []

          instance_exec(&block) if block_given?
        end

        def to_s
          'native source'
        end

        attr_reader :imports

        def language
          :native
        end

        def native?
          true
        end

        def files
          @imports.flat_map do |pattern|
            Dir.glob pattern
          end.uniq
        end

        def validate!
          raise "#{self} references no source files" if @imports.empty?
        end
      end
    end
  end
end
