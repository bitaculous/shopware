require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module PropertyGroups
        module List
          def self.included(thor)
            thor.class_eval do
              desc 'list', 'List property groups'
              def list
                property_groups = @client.get_property_groups
                quantity        = property_groups.size

                if quantity > 0
                  table = Terminal::Table.new headings: ['ID', 'Name']

                  get_property_groups.each_with_index do |get_property_group|
                    id   = get_property_group['id']
                    name = get_property_group['name']

                    table << [id, name]
                  end

                  puts table
                else
                  info 'No property groups found.'
                end
              end
            end
          end
        end
      end
    end
  end
end