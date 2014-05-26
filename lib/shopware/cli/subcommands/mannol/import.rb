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
              option :price, type: :numeric, default: 999
              option :in_stock, type: :numeric, default: 15
              option :stockmin, type: :numeric, default: 1
              option :content_configurator_set_name, type: :string, default: 'Inhalt'
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
                      article = @client.find_article_by_name product.name

                      if not article
                        data = get_article_data product, options

                        article = @client.create_article data

                        if article
                          variants = product.variants

                          variants.sort! { |x, y| x.purchase_unit <=> y.purchase_unit }

                          variants.each do |variant|
                            data = get_variant_data(article, variant, options)

                            variant = @client.create_variant data

                            if not variant
                              error 'Uuuuuppppss, something went wrong while creating variant.', indent: true if options.verbose?
                            end
                          end
                        else
                          error 'Uuuuuppppss, something went wrong while creating product.', indent: true if options.verbose?
                        end
                      else
                        warning 'Product already exists, skipping...', indent: true if options.verbose?
                      end
                    else
                      warning 'Product is not valid, skipping...', indent: true if options.verbose?

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

              def get_article_data(product, options)
                data = {
                  name: product.name,
                  descriptionLong: product.description,
                  supplier: product.supplier,
                  tax: 19,
                  mainDetail: {
                    number: product.number,
                    prices: [
                      {
                        customerGroupKey: 'EK',
                        price: options.price
                      }
                    ]
                  },
                  configuratorSet: {
                    groups: []
                  },
                  active: true
                }

                content_configurator_set = {
                  name: options.content_configurator_set_name,
                  options: []
                }

                product.content_options.each do |option|
                  content_configurator_set[:options] << { name: option }
                end

                data[:configuratorSet][:groups] << content_configurator_set

                data
              end

              def get_variant_data(article, variant, options)
                data = {
                  articleId: article['id'],
                  number: variant.number,
                  supplierNumber: variant.supplier_number,
                  additionaltext: variant.content,
                  purchaseUnit: variant.purchase_unit,
                  referenceUnit: variant.reference_unit,
                  unitId: variant.unit_id,
                  inStock: options.in_stock,
                  stockmin: options.stockmin,
                  prices: [
                    {
                      customerGroupKey: 'EK',
                      price: options.price
                    }
                  ],
                  configuratorOptions: [],
                  active: true
                }

                data[:configuratorOptions] << {
                  group: options.content_configurator_set_name,
                  option: variant.content
                }

                data
              end

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