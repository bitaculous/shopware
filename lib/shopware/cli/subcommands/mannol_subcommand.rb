require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/mannol/helpers'
require 'shopware/cli/subcommands/mannol/import'
require 'shopware/cli/subcommands/mannol/import/oils'
require 'shopware/cli/subcommands/mannol/import/care_products'

module Shopware
  module CLI
    module Subcommands
      class MannolSubcommand < Subcommand
        include Mannol::Helpers
        include Mannol::Import
        include Mannol::Import::Oils
        include Mannol::Import::CareProducts
      end
    end
  end
end