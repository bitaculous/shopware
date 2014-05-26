require 'json'
require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module Variants
        module Show
          def self.included(thor)
            thor.class_eval do
              desc 'show ID', 'Show variant with ID'
              option :dump, type: :boolean, default: false, aliases: '-d'
              def show(id)
                variant = @client.get_variant id

                if variant
                  if not options.dump
                    id   = variant['id']
                    name = variant['name']

                    table = Terminal::Table.new headings: ['Property', 'Value'] do |table|
                      table << ['ID', id]     if id
                      table << ['Name', name] if name
                    end

                    puts table
                  else
                    puts JSON.pretty_generate variant
                  end
                else
                  info 'Variant was not found.'
                end
              end
            end
          end
        end
      end
    end
  end
end