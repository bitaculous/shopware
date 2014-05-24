require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module Articles
        module List
          def self.included(thor)
            thor.class_eval do
              desc 'list', 'List articles'
              def list
                articles = @client.get_articles

                articles.each_with_index do |article, i|
                  id   = article['id']
                  name = article['name']

                  table = Terminal::Table.new headings: ['Property', 'Value'] do |table|
                    table << ['ID', id]     if id
                    table << ['Name', name] if name
                  end

                  puts "#{table}\n"
                end
              end
            end
          end
        end
      end
    end
  end
end