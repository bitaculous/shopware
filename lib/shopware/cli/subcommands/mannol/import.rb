require 'pp'

require 'shopware/cli/subcommands/mannol/import/validator'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          def self.included(thor)
            thor.class_eval do
              desc 'import [FILE]', 'Import products as a CSV file'
              option :products_category_id, type: :string, required: true
              option :car_manufacturer_category_id, type: :string, required: true
              option :category_template, type: :string, default: 'article_listing_1col.tpl'
              def import(file)
                if File.exist? file
                  info "Processing `#{File.basename file}`..." if options.verbose?

                  col_sep    = options.import['column_separator'] || '|'
                  quote_char = options.import['quote_character'] || '"'

                  data     = CSV.read file, col_sep: col_sep , quote_char: quote_char
                  quantity = data.length

                  data.each_with_index do |row, i|
                    index = i + 1

                    info "Processing #{index} of #{quantity} entries..." if options.verbose?

                    dao = OpenStruct.new(
                      category:                  row[0],
                      subcategory:               row[1],
                      subcategory_text:          row[2],
                      subsubcategory:            row[3],
                      brand:                     row[4],
                      number:                    row[5],
                      name:                      row[6],
                      content:                   row[7],
                      content_unit:              row[8],
                      order_number:              row[9],
                      description:               row[10],
                      code:                      row[11],
                      car_manufacturer_category: row[12],
                      car_category:              row[13],
                      property:                  row[14],
                      test_method:               row[15],
                      property_value:            row[16],
                      property_unit:             row[17],
                      image_small:               row[18],
                      image_big:                 row[19]
                    )

                    validator = Validator.new dao

                    if validator.valid?
                      # === Categories ===

                      category = find_or_create_category(
                        name: dao.category,
                        template: options[:category_template],
                        parent_id: options[:products_category_id]
                      )

                      if dao.subcategory
                        subcategory = find_or_create_category(
                          name: dao.subcategory,
                          text: dao.subcategory_text,
                          template: options[:category_template],
                          parent_id: category['id']
                        )

                        if dao.subsubcategory
                          subsubcategory = find_or_create_category(
                            name: dao.subsubcategory,
                            template: options[:category_template],
                            parent_id: subcategory['id']
                          )
                        end
                      end

                      if dao.car_manufacturer_category
                        car_manufacturer_category = find_or_create_category(
                          name: dao.car_manufacturer_category,
                          template: options[:category_template],
                          parent_id: options[:car_manufacturer_category_id]
                        )

                        if dao.car_category
                          car_category = find_or_create_category(
                            name: dao.car_category,
                            template: options[:category_template],
                            parent_id: car_manufacturer_category['id']
                          )
                        end
                      end
                    else
                      warning 'Entry is not valid, skipping...', indent: true if options.verbose?

                      validator.errors.each do |error|
                        property = error.first
                        label    = property.to_s.capitalize

                        error "#{label} not valid.", indent: true if options.verbose?
                      end
                    end
                  end
                else
                  error "File: `#{file}` not found." if options.verbose?
                end

                ok 'Import finished.' if options.verbose?
              end

              private

              def find_or_create_category(name:, text: nil, template: 'article_listing_1col.tpl', parent_id:)
                transient = @client.find_category_by_name name

                if not transient
                  info "Category “#{name}” does not exists, creating new one...", indent: true if options.verbose?

                  properties = {
                    name: name,
                    cmsHeadline: name,
                    template: template,
                    parentId: parent_id
                  }

                  properties[:cmsText] = text if text and not text.empty?

                  category = @client.create_category properties

                  @client.get_category category['id']
                else
                  info "Category “#{name}” already exists.", indent: true if options.verbose?

                  transient
                end
              end

              def create_or_update_category(name:, text: nil, template: 'article_listing_1col.tpl', parent_id:)
                transient = @client.find_category_by_name name

                properties = {
                  name: name,
                  cmsHeadline: name,
                  template: template,
                  parentId: parent_id
                }

                properties[:cmsText] = text if text and not text.empty?

                if not transient
                  info "Category “#{name}” does not exists, creating new one...", indent: true if options.verbose?

                  category = @client.create_category properties

                  @client.get_category category['id']
                else
                  info "Category “#{name}” already exists, updating category...", indent: true if options.verbose?

                  @client.update_category transient['id'], properties
                end
              end
            end
          end
        end
      end
    end
  end
end