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
                quantity = articles.size

                if quantity > 0
                  articles.each_with_index do |article, i|
                    id   = article['id']
                    name = article['name']

                    table = Terminal::Table.new headings: ['ID', 'Name'] do |table|
                      table << [id, name]
                    end

                    puts "#{table}\n"
                  end
                else
                  info 'No articles found.'
                end
              end
            end
          end
        end
      end
    end
  end
end