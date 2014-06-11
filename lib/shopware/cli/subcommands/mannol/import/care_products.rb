require 'shopware/cli/subcommands/mannol/import/models/care_product'
require 'shopware/cli/subcommands/mannol/import/models/variant'
require 'shopware/cli/subcommands/mannol/import/readers/care_product'
require 'shopware/cli/subcommands/mannol/import/validators/care_product'
require 'shopware/cli/subcommands/mannol/import/validators/variant'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module CareProducts
            def self.included(thor)
              thor.class_eval do
                desc 'import_care_products [FILE]', 'Import care products as a CSV file'
                option :root_category_id, type: :numeric, required: true
                option :asset_host, type: :string, default: 'sct-catalogue.de'
                option :small_image_path, type: :string, default: '/imgbank/Image/public/images/bilder_chemie/small'
                option :big_image_path, type: :string, default: '/imgbank/Image/public/images/bilder_chemie/big'
                option :number_of_care_products, type: :numeric, default: -1
                option :defaults, type: :hash, default: {
                  'price'                         => 999,
                  'in_stock'                      => 15,
                  'stockmin'                      => 1,
                  'content_configurator_set_name' => 'Inhalt',
                  'category_template'             => 'article_listing_1col.tpl'
                }
                def import_care_products(file)
                  defaults = options.defaults

                  if File.exist? file
                    info "Processing `#{File.basename file}`..." if options.verbose?

                    reader = Readers::CareProduct.new(
                      file: file,
                      column_separator: options.import['column_separator'],
                      quote_character: options.import['quote_character']
                    )

                    care_products = reader.care_products
                    quantity      = care_products.length

                    info "Found #{quantity} care product(s)." if options.verbose?

                    care_products.each_with_index do |care_product, i|
                      return if i == options.number_of_care_products

                      index = i + 1

                      name = care_product.name

                      info "Processing #{index}. care product “#{name}” of #{quantity}..." if options.verbose?

                      care_product_validator = Validators::CareProduct.new care_product

                      if care_product_validator.valid?
                        article = @client.find_article_by_name name

                        if not article
                          categories = get_categories_for_care_product(
                            care_product: care_product,
                            options: options,
                            defaults: defaults
                          )

                          data = get_article_data_for_care_product(
                            care_product: care_product,
                            categories: categories,
                            options: options,
                            defaults: defaults
                          )

                          article = @client.create_article data

                          if article
                            variants = care_product.variants.sort_by { |variant| (variant.content_value || 0).to_f }

                            variants.each do |variant|
                              variant_validator = Validators::Variant.new variant

                              if variant_validator.valid?
                                data = get_variant_data_for_care_product(
                                  article: article,
                                  variant: variant,
                                  options: options,
                                  defaults: defaults
                                )

                                variant = @client.create_variant data

                                if not variant
                                  error 'Uuuuuppppss, something went wrong while creating variant.', indent: true if options.verbose?
                                end
                              else
                                error 'Variant is not valid, skipping...', indent: true if options.verbose?

                                variant_validator.errors.each do |error|
                                  property = error.first
                                  label    = property.to_s.capitalize

                                  error "#{label} not valid.", indent: true if options.verbose?
                                end
                              end
                            end
                          else
                            error 'Uuuuuppppss, something went wrong while creating oil.', indent: true if options.verbose?
                          end
                        else
                          warning 'Care product already exists, skipping...', indent: true if options.verbose?
                        end
                      else
                        error 'Care product is not valid, skipping...', indent: true if options.verbose?

                        care_product_validator.errors.each do |error|
                          property = error.first
                          label    = property.to_s.capitalize

                          error "#{label} not valid.", indent: true if options.verbose?
                        end
                      end
                    end

                    ok 'Import finished.'
                  else
                    error "File: `#{file}` not found." if options.verbose?
                  end
                end

                private

                def get_categories_for_care_product(care_product:, options:, defaults:)
                  categories = []

                  category = care_product.category

                  if category
                    category = find_or_create_category(
                      name: category,
                      template: defaults['category_template'],
                      parent_id: options.root_category_id
                    )

                    if category
                      categories << category['id']

                      subcategory = care_product.subcategory

                      if subcategory
                        subcategory = find_or_create_category(
                          name: subcategory,
                          template: defaults['category_template'],
                          parent_id: category['id']
                        )

                        if subcategory
                          categories << subcategory['id']
                        else
                          error 'Uuuuuppppss, something went wrong while creating subcategory.', indent: true if options.verbose?
                        end
                      end
                    else
                      error 'Uuuuuppppss, something went wrong while creating category.', indent: true if options.verbose?
                    end
                  end

                  categories
                end

                def get_article_data_for_care_product(care_product:, categories:, options:, defaults:)
                  number          = care_product.number
                  name            = care_product.name
                  description     = care_product.description
                  instruction     = care_product.instruction
                  supplier        = care_product.supplier
                  small_image     = care_product.small_image
                  big_image       = care_product.big_image
                  content_options = care_product.content_options

                  description = enclose description

                  if instruction
                    instruction = enclose instruction

                    description += instruction
                  end

                  data = {
                    name: name,
                    descriptionLong: description,
                    supplier: supplier,
                    tax: 19,
                    mainDetail: {
                      number: number,
                      propertyGroup: '2',
                      prices: [
                        {
                          customerGroupKey: 'EK',
                          price: defaults['price']
                        }
                      ]
                    },
                    images: [],
                    categories: [],
                    configuratorSet: {
                      groups: []
                    },
                    active: true
                  }

                  image = find_image(
                    small_image: small_image,
                    big_image: big_image,
                    options: options
                  )

                  if image
                    data[:images] << { link: image }
                  end

                  if not categories.empty?
                    categories.each do |category|
                      data[:categories] << { id: category }
                    end
                  end

                  if not content_options.empty?
                    content_configurator_set = {
                      name: defaults['content_configurator_set_name'],
                      options: []
                    }

                    content_options.each do |option|
                      content_configurator_set[:options] << { name: option } if option
                    end

                    data[:configuratorSet][:groups] << content_configurator_set if content_configurator_set
                  end

                  data
                end

                def get_variant_data_for_care_product(article:, variant:, options:, defaults:)
                  article_id      = article['id']
                  number          = variant.number
                  supplier_number = variant.supplier_number
                  content         = variant.content
                  purchase_unit   = variant.purchase_unit
                  reference_unit  = variant.reference_unit
                  unit_id         = variant.unit_id
                  small_image     = variant.small_image
                  big_image       = variant.big_image

                  data = {
                    articleId: article_id,
                    number: number,
                    supplierNumber: supplier_number,
                    additionaltext: content,
                    purchaseUnit: purchase_unit,
                    referenceUnit: reference_unit,
                    unitId: unit_id,
                    inStock: defaults['in_stock'],
                    stockmin: defaults['stockmin'],
                    prices: [
                      {
                        customerGroupKey: 'EK',
                        price: defaults['price']
                      }
                    ],
                    images: [],
                    configuratorOptions: [],
                    active: true
                  }

                  image = find_image(
                    small_image: small_image,
                    big_image: big_image,
                    options: options
                  )

                  if image
                    data[:images] << { link: image }
                  end

                  if content
                    data[:configuratorOptions] << {
                      group: defaults['content_configurator_set_name'],
                      option: content
                    }
                  end

                  data
                end
              end
            end
          end
        end
      end
    end
  end
end