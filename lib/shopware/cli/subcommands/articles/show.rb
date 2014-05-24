require 'pp'
require 'terminal-table'

module Shopware
  module CLI
    module Subcommands
      module Articles
        module Show
          def self.included(thor)
            thor.class_eval do
              desc 'show ID', 'Show article with ID'
              class_option :dump, type: :boolean, default: false, aliases: '-d'
              def show(id)
                article = @client.get_article id

                if article
                  if options.dump
                    pp article
                  else
                    id   = article['id']
                    name = article['name']

                    table = Terminal::Table.new headings: ['Property', 'Value'] do |table|
                      table << ['ID', id]     if id
                      table << ['Name', name] if name
                    end

                    puts table
                  end
                else
                  info 'Article was not found.'
                end
              end
            end
          end
        end
      end
    end
  end
end