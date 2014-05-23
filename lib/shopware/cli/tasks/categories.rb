require 'terminal-table'

module Shopware
  module CLI
    module Tasks
      module Categories
        def self.included(thor)
          thor.class_eval do
            desc 'categories', 'List categories'
            def categories
              categories = @client.get_categories

              categories.each_with_index do |category, i|
                id             = category['id']
                name           = category['name']
                active         = category['active']
                position       = category['position']
                parent_id      = category['parentId']
                children_count = category['childrenCount']
                article_count  = category['articleCount']

                table = Terminal::Table.new headings: ['Property', 'Value'] do |table|
                  table << ['ID', id]                         if id
                  table << ['Name', name]                     if name
                  table << ['Active', active]                 if active
                  table << ['Position', position]             if position
                  table << ['Parentable ID', parent_id]       if parent_id
                  table << ['Children count', children_count] if children_count
                  table << ['Article count', article_count]   if article_count
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