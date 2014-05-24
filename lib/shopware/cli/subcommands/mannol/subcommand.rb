require 'thor'

require 'shopware/api/client'
require 'shopware/cli/subcommands/mannol/import'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        class Subcommand < Thor
          attr_reader :client

          def initialize(*args)
            super

            @client = API::Client.new options.api
          end

          include Import
        end
      end
    end
  end
end