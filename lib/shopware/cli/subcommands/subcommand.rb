require 'thor'

require 'shopware/api/client'
require 'shopware/cli/config'
require 'shopware/cli/shell'

module Shopware
  module CLI
    module Subcommands
      class Subcommand < Thor
        attr_reader :client

        include Config

        include Shell

        def initialize(*args)
          super

          @client = API::Client.new options.api
        end
      end
    end
  end
end