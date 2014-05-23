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

                rows = []
                rows << ['ID', id]                         if id
                rows << ['Name', name]                     if name
                rows << ['Active', active]                 if active
                rows << ['Position', position]             if position
                rows << ['Parent ID', parent_id]           if parent_id
                rows << ['Children count', children_count] if children_count
                rows << ['Article count', article_count]   if article_count

                table = ::Terminal::Table.new rows: rows

                puts table
              end
            end
          end
        end
      end
    end
  end
end