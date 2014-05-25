require 'pp'

require 'shopware/cli/subcommands/mannol/import/models/product'
require 'shopware/cli/subcommands/mannol/import/models/variant'
require 'shopware/cli/subcommands/mannol/import/reader'
require 'shopware/cli/subcommands/mannol/import/validators/product'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          def self.included(thor)
            thor.class_eval do
              desc 'import [FILE]', 'Import products as a CSV file'
              option :root_category_id, type: :string, required: true
              option :car_manufacturer_category_id, type: :string, required: true
              option :category_template, type: :string, default: 'article_listing_1col.tpl'
              def import(file)
                if File.exist? file
                  info "Processing `#{File.basename file}`..." if options.verbose?

                  reader = Reader.new file, options.import['column_separator'], options.import['quote_character']

                  products = reader.products
                  quantity = products.length

                  info "Found #{quantity} product(s)." if options.verbose?

                  products = reader.products
                  quantity = products.length

                  products.each_with_index do |product, i|
                    index = i + 1

                    info "Processing #{index}. product “#{product.name}” of #{quantity}..." if options.verbose?

                    validator = Validators::Product.new product

                    if validator.valid?
                      pp 'Foo'
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
              end

              private

              def find_or_create_category(name:, template:, parent_id:, text: nil)
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

              def create_or_update_category(name:, template:, parent_id:, text: nil)
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