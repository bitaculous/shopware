require 'thor'

require 'shopware/cli/subcommands/articles_subcommand'
require 'shopware/cli/subcommands/categories_subcommand'
require 'shopware/cli/subcommands/property_groups_subcommand'
require 'shopware/cli/subcommands/variants_subcommand'
require 'shopware/cli/subcommands/mannol_subcommand'

module Shopware
  module CLI
    class Runner < Thor
      class_option :verbose, type: :boolean, default: false, aliases: '-v'

      include Thor::Actions
      include Thor::Shell

      desc 'articles [SUBCOMMAND]', 'Manage articles'
      subcommand :articles, Subcommands::ArticlesSubcommand

      desc 'categories [SUBCOMMAND]', 'Manage categories'
      subcommand :categories, Subcommands::CategoriesSubcommand

      desc 'property_groups [SUBCOMMAND]', 'Manage property groups'
      subcommand :property_groups, Subcommands::PropertyGroupsSubcommand

      desc 'variants [SUBCOMMAND]', 'Manage variants'
      subcommand :variants, Subcommands::VariantsSubcommand

      desc 'mannol [SUBCOMMAND]', 'Mannol specific commands'
      subcommand :mannol, Subcommands::MannolSubcommand
    end
  end
end