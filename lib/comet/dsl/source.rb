module Comet
  module DSL
    class Source
      class << self
        def create(language:, **kwargs, &block)
          raise "unknown language #{language}" unless valid? language
          LANGUAGES[language].new(**kwargs, &block) # pass extra args
        end

        private

        LANGUAGES = {
          c: C::Source,
          cpp: CPP::Source,
          native: Native::Source
        }.freeze

        def valid?(language)
          LANGUAGES.keys.include? language
        end
      end
    end
  end
end
