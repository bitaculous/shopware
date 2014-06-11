require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/mannol/helpers'
require 'shopware/cli/subcommands/mannol/import/oils'

module Shopware
  module CLI
    module Subcommands
      class MannolSubcommand < Subcommand
        include Mannol::Helpers
        include Mannol::Import::Oils
      end
    end
  end
end