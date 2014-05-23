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

                table = Terminal::Table.new headings: ['Property', 'Value'] do |t|
                  t << ['ID', id]                         if id
                  t << ['Name', name]                     if name
                  t << ['Active', active]                 if active
                  t << ['Position', position]             if position
                  t << ['Parent ID', parent_id]           if parent_id
                  t << ['Children count', children_count] if children_count
                  t << ['Article count', article_count]   if article_count
                end

                puts table
              end
            end
          end
        end
      end
    end
  end
end