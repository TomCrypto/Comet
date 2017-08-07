module Comet
  module DSL
    module Helpers
      def quote(string)
        "\\\"#{string.strip}\\\""
      end
    end
  end
end
