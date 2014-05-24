require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/categories/list'
require 'shopware/cli/subcommands/categories/delete'

module Shopware
  module CLI
    module Subcommands
      class CategoriesSubcommand < Subcommand
        include Categories::List
        include Categories::Delete
      end
    end
  end
end