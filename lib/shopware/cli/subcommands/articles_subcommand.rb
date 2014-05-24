require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/articles/list'

module Shopware
  module CLI
    module Subcommands
      class ArticlesSubcommand < Subcommand
        include Articles::List
      end
    end
  end
end