require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/mannol/import'

module Shopware
  module CLI
    module Subcommands
      class MannolSubcommand < Subcommand
        include Mannol::Import
      end
    end
  end
end