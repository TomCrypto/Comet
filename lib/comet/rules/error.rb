module Comet
  module Rules
    class Error
      def initialize(message)
        @message = message
      end

      def target
        nil
      end

      def contents
        ["$(error #{pretty_message})"]
      end

      def rules
        []
      end

      def commands
        {}
      end

      private

      def pretty_message
        words = @message.split
        words.first.capitalize!
        words.join ' '
      end
    end
  end
end
