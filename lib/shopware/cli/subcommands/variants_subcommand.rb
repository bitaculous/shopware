require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/variants/show'
require 'shopware/cli/subcommands/variants/delete'

module Shopware
  module CLI
    module Subcommands
      class VariantsSubcommand < Subcommand
        include Variants::Show
        include Variants::Delete
      end
    end
  end
end