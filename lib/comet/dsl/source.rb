module Comet
  module DSL
    class Source
      class << self
        def create(language:, **kwargs, &block)
          raise "unknown language #{language}" unless valid? language
          LANGUAGES[language].call(**kwargs, &block)
        end

        private

        LANGUAGES = {
          c: proc do |**kwargs, &block|
            CLike::Source.new(language: :c, **kwargs, &block)
          end,
          cpp: proc do |**kwargs, &block|
            CLike::Source.new(language: :cpp, **kwargs, &block)
          end,
          native: proc do |**kwargs, &block|
            Native::Source.new(**kwargs, &block)
          end
        }.freeze

        def valid?(language)
          LANGUAGES.keys.include? language
        end
      end
    end
  end
end
