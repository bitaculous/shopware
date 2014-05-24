require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/articles/list'
require 'shopware/cli/subcommands/articles/show'
require 'shopware/cli/subcommands/articles/delete'

module Shopware
  module CLI
    module Subcommands
      class ArticlesSubcommand < Subcommand
        include Articles::List
        include Articles::Show
        include Articles::Delete
      end
    end
  end
end