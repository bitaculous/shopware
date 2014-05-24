require 'thor'

require 'shopware/api/client'
require 'shopware/cli/config'
require 'shopware/cli/shell'
require 'shopware/cli/tasks/categories'
require 'shopware/cli/tasks/import'

module Shopware
  module CLI
    class Runner < Thor
      attr_reader :client

      class_option :verbose, type: :boolean, default: false

      include Thor::Actions
      include Thor::Shell

      include Config

      include Shell

      def initialize(*args)
        super

        @client = API::Client.new options.api
      end

      include Tasks::Import

      include Tasks::Categories
    end
  end
end