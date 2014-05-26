require 'shopware/cli/subcommands/subcommand'
require 'shopware/cli/subcommands/property_groups/list'
require 'shopware/cli/subcommands/property_groups/show'
require 'shopware/cli/subcommands/property_groups/delete'

module Shopware
  module CLI
    module Subcommands
      class PropertyGroupsSubcommand < Subcommand
        include PropertyGroups::List
        include PropertyGroups::Show
        include PropertyGroups::Delete
      end
    end
  end
end