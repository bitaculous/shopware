require 'thor'

require 'shopware/cli/config'
require 'shopware/cli/shell'
require 'shopware/cli/subcommands/categories'
require 'shopware/cli/subcommands/mannol/subcommand'

module Shopware
  module CLI
    class Runner < Thor
      class_option :verbose, type: :boolean, default: false, aliases: '-v'

      include Thor::Actions
      include Thor::Shell

      include Config

      include Shell

      desc 'categories [SUBCOMMAND]', 'Manage categories'
      subcommand 'categories', Subcommands::Categories

      desc 'mannol [SUBCOMMAND]', 'Mannol specific commands'
      subcommand 'mannol', Subcommands::Mannol::Subcommand
    end
  end
end