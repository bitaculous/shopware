require 'thor'
require 'pp'

require_relative 'api/client'

module Shopware
  class CLI < Thor
    CONFIG = '.shopware'

    desc 'categories', 'Gets categories'
    def categories
      client = API::Client.new options.api

      pp client.categories
    end

    private

    def options
      original_options = super

      return original_options unless File.exists? CONFIG

      defaults = ::YAML::load_file CONFIG || {}

      Thor::CoreExt::HashWithIndifferentAccess.new defaults.merge(original_options) if defaults
    end
  end
end