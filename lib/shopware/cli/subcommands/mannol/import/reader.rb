require 'csv'
require 'securerandom'

require 'shopware/cli/subcommands/mannol/import/models/product'
require 'shopware/cli/subcommands/mannol/import/models/variant'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          class Reader
            attr_reader :csv, :headers, :quantity

            def initialize(file:, column_separator: '|', quote_character: '"')
              options = {
                headers: :first_row,
                header_converters: :symbol,
                converters: [:numeric, :float],
                col_sep: column_separator,
                quote_char: quote_character
              }

              @csv      = CSV.read file, options
              @headers  = @csv.headers
              @quantity = @csv.length
            end

            def products
              products = @csv[:name].uniq

              products.map do |name|
                product name
              end
            end

            def product(name)
              product = Models::Product.new

              full = search(
                criterions: {
                  name: name
                }
              )

              entity = find(
                criterions: {
                  name: name
                },
                data: full
              )

              product.number       = generate_number
              product.name         = name
              product.code         = entity[:code]
              product.order_number = entity[:order_number]
              product.description  = entity[:description]
              product.supplier     = entity[:supplier]

              properties = column(
                key: :property,
                data: full
              )

              properties.each do |property|
                data = find(
                  criterions: {
                    property: property
                  },
                  data: full
                )

                value = data[:property_value]

                if value
                  name        = property
                  test_method = data[:property_test_method]

                  name = "#{name} (#{test_method})" if test_method

                  product.properties << { name: name, value: value }
                end
              end

              product.small_image = entity[:small_image]
              product.big_image   = entity[:big_image]

              product.category                = entity[:category]
              product.subcategory             = entity[:subcategory]
              product.subcategory_description = entity[:subcategory_description]
              product.subsubcategory          = entity[:subsubcategory]

              car_manufacturer_categories = column(
                key: :car_manufacturer_category,
                data: full
              )

              if not car_manufacturer_categories.empty?
                car_manufacturer_categories.each do |car_manufacturer_category|
                  product.car_manufacturer_categories << { name: car_manufacturer_category }
                end

                car_categories = column(
                  key: :car_category,
                  data: full
                )

                if not car_categories.empty?
                  car_categories.each do |car_category|
                    data = find(
                      criterions: {
                        car_category: car_category
                      },
                      data: full
                    )

                    car_manufacturer = data[:car_manufacturer_category]

                    if car_manufacturer
                      product.car_categories << { name: car_category, car_manufacturer: car_manufacturer }
                    end
                  end
                end
              end

              numbers = column(
                key: :number,
                data: full
              )

              numbers.each do |number|
                variant = Models::Variant.new

                material = find_all(
                  criterions: {
                    number: number
                  },
                  data: full
                )

                one = find(
                  criterions: {
                    number: number
                  },
                  data: material
                )

                variant.number          = number
                variant.supplier_number = number
                variant.content_value   = one[:content_value]
                variant.content_unit    = one[:content_unit]
                variant.small_image     = one[:small_image]
                variant.big_image       = one[:big_image]

                product.variants.push variant
              end

              product
            end

            private

            def generate_number
              SecureRandom.hex 10
            end

            def search(criterions:)
              matches = @csv.find_all do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def find(criterions:, data:)
              matches = data.find do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def find_all(criterions:, data:)
              matches = data.find_all do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def column(key:, data:)
              data.map { |row| row[key] }.compact.uniq
            end
          end
        end
      end
    end
  end
end