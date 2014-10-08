require 'shopware/cli/subcommands/mannol/import/models/oil'
require 'shopware/cli/subcommands/mannol/import/models/variant'
require 'shopware/cli/subcommands/mannol/import/readers/oil'
require 'shopware/cli/subcommands/mannol/import/validators/oil'
require 'shopware/cli/subcommands/mannol/import/validators/variant'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Oils
            SPEC_CATEGORIES_AS_PROPERTIES = %w[ACEA API SAE]

            def self.included(thor)
              thor.class_eval do
                desc 'import_oils [FILE]', 'Import oils as a CSV file'
                option :oil_category_id, type: :numeric, required: true
                option :spec_category_id, type: :numeric, required: true
                option :filter_group_id, type: :numeric, required: true
                option :asset_host, type: :string, default: 'sct-catalogue.de'
                option :small_image_path, type: :string, default: '/imgbank/Image/public/images/bilder_chemie/small'
                option :big_image_path, type: :string, default: '/imgbank/Image/public/images/bilder_chemie/big'
                option :number_of_oils, type: :numeric, default: -1
                option :defaults, type: :hash, default: {
                  'price'                         => 999,
                  'in_stock'                      => 15,
                  'stockmin'                      => 1,
                  'content_configurator_set_name' => 'Inhalt',
                  'category_template'             => 'article_listing_1col.tpl',
                  'specifications_heading'        => 'Spezifikationen:'
                }
                def import_oils(file)
                  defaults = options.defaults

                  if File.exist? file
                    info "Processing `#{File.basename file}`..." if options.verbose?

                    reader = Readers::Oil.new(
                      file: file,
                      column_separator: options.import['column_separator'],
                      quote_character: options.import['quote_character']
                    )

                    oils     = reader.oils
                    quantity = oils.length

                    info "Found #{quantity} oil(s)." if options.verbose?

                    oils.each_with_index do |oil, i|
                      return if i == options.number_of_oils

                      index = i + 1

                      name = oil.name

                      info "Processing #{index}. oil “#{name}” of #{quantity}..." if options.verbose?

                      oil_validator = Validators::Oil.new oil

                      if oil_validator.valid?
                        article = @client.find_article_by_name name

                        if not article
                          categories = get_categories_for_oil(
                            oil: oil,
                            options: options,
                            defaults: defaults
                          )

                          data = get_article_data_for_oil(
                            oil: oil,
                            categories: categories,
                            options: options,
                            defaults: defaults
                          )

                          article = @client.create_article data

                          if article
                            ok "Oil “#{name}” created.", indent: true
                          else
                            error "Uuuuuppppss, something went wrong while creating oil “#{name}”.", indent: true if options.verbose?
                          end
                        else
                          warning "Oil “#{name}” already exists, skipping...", indent: true if options.verbose?
                        end
                      else
                        error "Oil “#{name}” is not valid, skipping...", indent: true if options.verbose?

                        oil_validator.errors.each do |error|
                          property = error.first
                          label    = property.to_s.capitalize

                          error "#{label} not valid.", indent: true if options.verbose?
                        end
                      end
                    end

                    ok 'Import finished.'
                  else
                    error "File `#{file}` not found." if options.verbose?
                  end
                end

                private

                def get_categories_for_oil(oil:, options:, defaults:)
                  categories = []

                  category = oil.category

                  if category
                    category = find_or_create_category(
                      name: category,
                      template: defaults['category_template'],
                      parent_id: options.oil_category_id
                    )

                    if category
                      categories << category['id']

                      subcategory = oil.subcategory

                      if subcategory
                        description = oil.subcategory_description

                        description = enclose description

                        subcategory = find_or_create_category(
                          name: subcategory,
                          text: description,
                          template: defaults['category_template'],
                          parent_id: category['id']
                        )

                        if subcategory
                          categories << subcategory['id']

                          subsubcategory = oil.subsubcategory

                          if subsubcategory
                            subsubcategory = find_or_create_category(
                              name: subsubcategory,
                              template: defaults['category_template'],
                              parent_id: subcategory['id']
                            )

                            if subsubcategory
                              categories << subsubcategory['id']
                            else
                              error 'Uuuuuppppss, something went wrong while creating subsubcategory.', indent: true if options.verbose?
                            end
                          end
                        else
                          error 'Uuuuuppppss, something went wrong while creating subcategory.', indent: true if options.verbose?
                        end
                      end
                    else
                      error 'Uuuuuppppss, something went wrong while creating category.', indent: true if options.verbose?
                    end
                  end

                  spec_categories = oil.spec_categories

                  if not spec_categories.empty?
                    spec_categories.each do |spec_category|
                      name = spec_category[:name]

                      spec_category = find_or_create_category(
                        name: name,
                        template: options.category_template,
                        parent_id: options.spec_category_id
                      )

                      if spec_category
                        categories << spec_category['id']
                      else
                        error 'Uuuuuppppss, something went wrong while creating spec category.', indent: true if options.verbose?
                      end
                    end
                  end

                  spec_subcategories = oil.spec_subcategories

                  if not spec_subcategories.empty?
                    spec_subcategories.each do |spec_subcategory|
                      name          = spec_subcategory[:name]
                      spec_category = spec_subcategory[:spec_category]

                      spec_category = find_or_create_category(
                        name: spec_category,
                        template: options.category_template,
                        parent_id: options.spec_category_id
                      )

                      if spec_category
                        spec_subcategory = find_or_create_category(
                          name: name,
                          template: options.category_template,
                          parent_id: spec_category['id']
                        )

                        if spec_subcategory
                          categories << spec_subcategory['id']
                        else
                          error 'Uuuuuppppss, something went wrong while creating spec subcategory.', indent: true if options.verbose?
                        end
                      else
                        error 'Uuuuuppppss, something went wrong while creating spec category for spec subcategory.', indent: true if options.verbose?
                      end
                    end
                  end

                  categories
                end

                def get_article_data_for_oil(oil:, categories:, options:, defaults:)
                  name               = oil.name
                  description        = oil.description
                  supplier           = oil.supplier
                  small_image        = oil.small_image
                  big_image          = oil.big_image
                  properties         = oil.properties
                  spec_categories    = oil.spec_categories
                  spec_subcategories = oil.spec_subcategories
                  variants           = oil.variants

                  number = generate_number(text: name)

                  long_description = get_long_description_for_oil(oil: oil, options: options, defaults: defaults)

                  data = {
                    name: name,
                    metaTitle: name,
                    description: description,
                    descriptionLong: long_description,
                    supplier: supplier,
                    tax: 19,
                    active: true,
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
                    filterGroupId: options.filter_group_id,
                    propertyValues: [],
                    configuratorSet: {
                      groups: []
                    },
                    variants: [],
                    images: [],
                    categories: []
                  }

                  if not properties.empty?
                    properties.each do |property|
                      name  = property[:name]
                      value = property[:value]

                      data[:propertyValues] << {
                        option: {
                          name: name
                        },

                        value: value
                      }
                    end
                  end

                  if not spec_subcategories.empty?
                    spec_subcategories.each do |spec_subcategory|
                      name          = spec_subcategory[:name]
                      spec_category = spec_subcategory[:spec_category]

                      if SPEC_CATEGORIES_AS_PROPERTIES.include? spec_category
                        data[:propertyValues] << {
                          option: {
                            name: spec_category
                          },

                          value: name
                        }
                      end
                    end
                  end

                  if not variants.empty?
                    content_configurator_set = {
                      name: defaults['content_configurator_set_name'],
                      options: []
                    }

                    variants = variants.sort_by { |variant| (variant.content_value || 0).to_f }

                    variants.each_with_index do |variant, index|
                      variant_validator = Validators::Variant.new variant

                      if variant_validator.valid?
                        variant_data = get_variant_data_for_oil(
                          oil: oil,
                          variant: variant,
                          options: options,
                          defaults: defaults,
                          index: index
                        )

                        data[:variants] << variant_data if variant_data

                        option = variant.content

                        content_configurator_set[:options] << { name: option, position: index } if option
                      else
                        error 'Variant is not valid, skipping...', indent: true if options.verbose?

                        variant_validator.errors.each do |error|
                          property = error.first
                          label    = property.to_s.capitalize

                          error "#{label} not valid.", indent: true if options.verbose?
                        end
                      end
                    end

                    data[:configuratorSet][:groups] << content_configurator_set if content_configurator_set
                  end

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

                  data
                end

                def get_long_description_for_oil(oil:, options:, defaults:)
                  description = oil.description

                  description_long = enclose description

                  spec_subcategories = oil.spec_subcategories

                  if not spec_subcategories.empty?
                    specifications = "<h2>#{defaults['specifications_heading']}</h2>"

                    specifications += '<ul>'

                    spec_subcategories.each do |spec_subcategory|
                      specifications += "<li>#{spec_subcategory[:spec_category]} #{spec_subcategory[:name]}</li>"
                    end

                    specifications += '</ul>'

                    description_long += specifications
                  end

                  description_long
                end

                def get_variant_data_for_oil(oil:, variant:, options:, defaults:, index:)
                  supplier_number = variant.supplier_number
                  content         = variant.content
                  purchase_unit   = variant.purchase_unit
                  reference_unit  = variant.reference_unit
                  unit_id         = variant.unit_id
                  small_image     = variant.small_image
                  big_image       = variant.big_image

                  number = generate_number text: oil.name, index: index

                  is_main = index == 0

                  data = {
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
                    configuratorOptions: [],
                    images: [],
                    isMain: is_main,
                    active: true
                  }

                  if content
                    data[:configuratorOptions] << {
                      group: defaults['content_configurator_set_name'],
                      option: content
                    }
                  end

                  image = find_image(
                    small_image: small_image,
                    big_image: big_image,
                    options: options
                  )

                  if image
                    data[:images] << { link: image }
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