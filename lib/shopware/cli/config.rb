module Shopware
  module CLI
    module Config
      CONFIG = '.shopware'

      private

      def options
        original_options = super

        return original_options unless File.exists? CONFIG

        defaults = ::YAML::load_file CONFIG || {}

        Thor::CoreExt::HashWithIndifferentAccess.new defaults.merge(original_options) if defaults
      end
    end
  end
end