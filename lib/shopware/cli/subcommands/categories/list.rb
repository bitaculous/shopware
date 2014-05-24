require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module Categories
        module List
          def self.included(thor)
            thor.class_eval do
              desc 'list', 'List categories'
              def list
                categories = @client.get_categories
                quantity   = categories.size

                if quantity > 0
                  table = Terminal::Table.new headings: ['ID', 'Name']

                  categories.each_with_index do |category|
                    id   = category['id']
                    name = category['name']

                    table << [id, name]
                  end

                  puts table
                else
                  info 'No categories found.'
                end
              end
            end
          end
        end
      end
    end
  end
end