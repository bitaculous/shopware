require 'csv'

module Shopware
  module CLI
    module Tasks
      module Import
        def self.included(thor)
          thor.class_eval do
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

                  category       = find_or_create_category name: category, template: options[:category_template], parent_id: options[:products_category_id]
                  subcategory    = find_or_create_category name: subcategory, text: subcategory_text, template: options[:category_template], parent_id: category['id']
                  subsubcategory = find_or_create_category name: subsubcategory, template: options[:category_template], parent_id: subcategory['id']
                end
              else
                error "File: `#{file}` not found."
              end
            end
          end
        end

        private

        def find_or_create_category(name:, text: nil, template:, parent_id:)
          transient = @client.find_category_by_name name

          if not transient
            properties = {
              name: name,
              cmsHeadline: name,
              template: template,
              parentId: parent_id
            }

            properties[:cmsText] = text if text

            category = @client.create_category properties

            client.get_category category['id']
          else
            transient
          end
        end
      end
    end
  end
end