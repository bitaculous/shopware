require 'shopware/cli/subcommands/mannol/import/models/filter'
require 'shopware/cli/subcommands/mannol/import/models/variant'
require 'shopware/cli/subcommands/mannol/import/readers/filter'
require 'shopware/cli/subcommands/mannol/import/validators/filter'
require 'shopware/cli/subcommands/mannol/import/validators/variant'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Filters
            def self.included(thor)
              thor.class_eval do
                desc 'import_filters [FILE]', 'Import filters as a CSV file'
                option :root_category_id, type: :numeric, required: true
                option :number_of_filters, type: :numeric, default: -1
                option :defaults, type: :hash, default: {
                  'price'             => 999,
                  'in_stock'          => 15,
                  'stockmin'          => 1,
                  'category_template' => 'article_listing_1col.tpl'
                }
                def import_filters(file)
                  defaults = options.defaults

                  if File.exist? file
                    info "Processing `#{File.basename file}`..." if options.verbose?

                    reader = Readers::Filter.new(
                      file: file,
                      column_separator: options.import['column_separator'],
                      quote_character: options.import['quote_character']
                    )

                    filters  = reader.filters
                    quantity = filters.length

                    info "Found #{quantity} filter(s)." if options.verbose?

                    filters.each_with_index do |filter, i|
                      return if i == options.number_of_filters

                      index = i + 1

                      name = filter.name

                      info "Processing #{index}. filter “#{name}” of #{quantity}..." if options.verbose?

                      filter_validator = Validators::Filter.new filter

                      if filter_validator.valid?
                        article = @client.find_article_by_name name

                        if not article
                          categories = get_categories_for_filter(
                            filter: filter,
                            options: options,
                            defaults: defaults
                          )

                          data = get_article_data_for_filter(
                            filter: filter,
                            categories: categories,
                            options: options,
                            defaults: defaults
                          )

                          article = @client.create_article data

                          if not article
                            error 'Uuuuuppppss, something went wrong while creating filter.', indent: true if options.verbose?
                          end
                        else
                          warning 'Filter already exists, skipping...', indent: true if options.verbose?
                        end
                      else
                        error 'Filter is not valid, skipping...', indent: true if options.verbose?

                        filter_validator.errors.each do |error|
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

                def get_categories_for_filter(filter:, options:, defaults:)
                  categories = []

                  category = filter.category

                  puts "Foo: #{category}"

                  if category
                    category = find_or_create_category(
                      name: category,
                      template: defaults['category_template'],
                      parent_id: options.root_category_id
                    )

                    if category
                      categories << category['id']

                      subcategory = filter.subcategory

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

                def get_article_data_for_filter(filter:, categories:, options:, defaults:)
                  number   = filter.number
                  name     = filter.name
                  supplier = filter.supplier

                  data = {
                    name: name,
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
                    categories: [],
                    active: true
                  }

                  if not categories.empty?
                    categories.each do |category|
                      data[:categories] << { id: category }
                    end
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