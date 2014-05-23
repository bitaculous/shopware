require 'csv'
require 'pp'
require 'terminal-table'
require 'thor'

require 'shopware/api/client'
require 'shopware/cli/config'
require 'shopware/cli/shell'

module Shopware
  module CLI
    class Runner < Thor
      attr_reader :client

      include Thor::Actions
      include Thor::Shell

      include Config

      include Shell

      def initialize(*args)
        super

        @client = API::Client.new options.api
      end

      desc 'import <file>', 'Import products as a CSV file'
      option :products_category_id, type: :string, required: true
      option :car_manufacturer_category_id, type: :string, required: true
      option :category_template, type: :string, default: 'Liste'
      option :verbose, type: :boolean, default: true
      def import(file)
        if File.exist? file
          info "Processing `#{File.basename file}`..." if options[:verbose]

          col_sep    = options.import['column_separator'] || '|'
          quote_char = options.import['quote_character'] || '"'

          data = CSV.read file, col_sep: col_sep , quote_char: quote_char
          quantity = data.length

          data.each_with_index do |row, i|
            info "Processing #{i + 1} of #{quantity} entries..." if options[:verbose]

            category         = row[0]
            subcategory      = row[1]
            subcategory_text = row[2]
            subsubcategory   = row[3]
            brand            = row[4]
            number           = row[5]
            name             = row[6]
            content          = row[7]
            content_unit     = row[8]
            order_number     = row[9]
            description      = row[10]
            code             = row[11]
            car_manufacturer = row[12]
            car_id           = row[13]
            property         = row[14]
            test_method      = row[15]
            property_value   = row[16]
            property_unit    = row[17]
            image_small      = row[18]
            image_big        = row[19]

            category = find_or_create_category category, options[:category_template], options[:products_category_id]
          end
        else
          error "File: `#{file}` not found."
        end
      end

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

      private

      def find_or_create_category(name, template, parent_id)
        transient = @client.find_category_by_name name

        if not transient
          category = @client.create_category({
            name: name,
            cmsHeadline: name,
            template: template,
            parentId: parent_id
          })

          client.get_category category['id']
        else
          transient
        end
      end
    end
  end
end