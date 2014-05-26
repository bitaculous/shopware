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

            def initialize(file, col_sep = '|', quote_char = '"')
              options = {
                headers: :first_row,
                header_converters: :symbol,
                converters: [:numeric, :float],
                col_sep: col_sep,
                quote_char: quote_char
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

              completely = search({
                name: name
              })

              entity = find({
                name: name
              }, completely)

              product.number       = generate_number
              product.name         = name
              product.code         = entity[:code]
              product.order_number = entity[:order_number]
              product.description  = entity[:description]
              product.supplier     = entity[:supplier]

              numbers = column(:number, completely).uniq

              numbers.each do |number|
                variant = Models::Variant.new

                material = find_all({
                  number: number
                }, completely)

                one = find({
                  number: number
                }, material)

                variant.number          = generate_number
                variant.supplier_number = number
                variant.content_value   = one[:content_value]
                variant.content_unit    = one[:content_unit]

                properties = column(:property, material).uniq

                properties.each do |property|
                  data = find({
                    property: property
                  }, material)

                  label       = property
                  test_method = data[:property_test_method]
                  value       = data[:property_value]

                  label = "#{property} (#{test_method})" if test_method

                  variant.properties << { label: label, value: value }
                end

                variant.image_small             = one[:image_small]
                variant.image_big               = one[:image_big]
                variant.category                = one[:category]
                variant.subcategory             = one[:subcategory]
                variant.subcategory_description = one[:subcategory_description]
                variant.subsubcategory          = one[:subsubcategory]

                car_categories = column(:car_category, material).uniq

                car_categories.each do |car_category|
                  data = find({
                    car_category: car_category
                  }, material)

                  label = car_category

                  car_manufacturer = data[:car_manufacturer_category]

                  variant.car_categories << { label: label, car_manufacturer: car_manufacturer }
                end

                product.variants.push variant
              end

              product
            end

            private

            def generate_number
              SecureRandom.hex 10
            end

            def search(criterions)
              matches = @csv.find_all do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def find(criterions, data)
              matches = data.find do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def find_all(criterions, data)
              matches = data.find_all do |row|
                match = true

                criterions.keys.each do |key|
                  match = match && (row[key] == criterions[key])
                end

                match
              end
            end

            def column(key, data)
              data.map { |row| row[key] }
            end
          end
        end
      end
    end
  end
end