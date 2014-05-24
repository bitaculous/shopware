module Shopware
  module CLI
    module Shell
      def info(message, indent = false)
        speak message, :white, indent
      end

      def ok(message, indent = false)
        speak message, :green, indent
      end

      def warning(message, indent = false)
        speak message, :yellow, indent
      end

      def error(message, indent = false)
        speak message, :red, indent
      end

      def speak(message, color, indent = false)
        if indent
          say "→ #{message}", color
        else
          say message, color
        end
      end
    end
  end
end