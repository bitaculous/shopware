require 'thor'

require 'shopware/cli/subcommands/articles_subcommand'
require 'shopware/cli/subcommands/categories_subcommand'
require 'shopware/cli/subcommands/property_groups_subcommand'
require 'shopware/cli/subcommands/variants_subcommand'

module Shopware
  module CLI
    class Runner < Thor
      include Thor::Actions
      include Thor::Shell

      class_option :verbose, type: :boolean, default: false, aliases: '-v'

      desc 'articles [SUBCOMMAND]', 'Manage articles'
      subcommand :articles, Subcommands::ArticlesSubcommand

      desc 'categories [SUBCOMMAND]', 'Manage categories'
      subcommand :categories, Subcommands::CategoriesSubcommand

      desc 'property_groups [SUBCOMMAND]', 'Manage property groups'
      subcommand :property_groups, Subcommands::PropertyGroupsSubcommand

      desc 'variants [SUBCOMMAND]', 'Manage variants'
      subcommand :variants, Subcommands::VariantsSubcommand
    end
  end
end