require 'json'
require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module PropertyGroups
        module Show
          def self.included(thor)
            thor.class_eval do
              desc 'show ID', 'Show property group with ID'
              option :dump, type: :boolean, default: false, aliases: '-d'
              def show(id)
                property_group = @client.get_property_group id

                if property_group
                  if not options.dump
                    id         = property_group['id']
                    name       = property_group['name']
                    position   = property_group['position']
                    comparable = property_group['comparable']
                    sort_mode  = property_group['sortMode']

                    table = Terminal::Table.new headings: ['Property', 'Value'] do |table|
                      table << ['ID', id]                 if id
                      table << ['Name', name]             if name
                      table << ['Position', position]     if position
                      table << ['Comparable', comparable] if comparable
                      table << ['Sort mode', sort_mode]   if sort_mode
                    end

                    puts table
                  else
                    puts JSON.pretty_generate property_group
                  end
                else
                  info 'Property group was not found.'
                end
              end
            end
          end
        end
      end
    end
  end
end