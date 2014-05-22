module Shopware
  module CLI
    module Shell
      def info(message)
        say message, :white if message
      end

      def warning(message)
        say message, :yellow if message
      end

      def error(message)
        say message, :red if message
      end
    end
  end
end