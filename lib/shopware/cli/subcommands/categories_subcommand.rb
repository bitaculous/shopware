require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/categories/list'

module Shopware
  module CLI
    module Subcommands
      class CategoriesSubcommand < Subcommand
        include Categories::List
      end
    end
  end
end