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

              full = search({
                name: name
              })

              entity = find({
                name: name
              }, full)

              product.number       = generate_number
              product.name         = name
              product.code         = entity[:code]
              product.order_number = entity[:order_number]
              product.description  = entity[:description]
              product.supplier     = entity[:supplier]

              properties = column(:property, full).compact.uniq

              properties.each do |property|
                data = find({
                  property: property
                }, full)

                value = data[:property_value]

                if value
                  name        = property
                  test_method = data[:property_test_method]

                  name = "#{name} (#{test_method})" if test_method

                  product.properties << { name: name, value: value }
                end
              end

              product.category                = entity[:category]
              product.subcategory             = entity[:subcategory]
              product.subcategory_description = entity[:subcategory_description]
              product.subsubcategory          = entity[:subsubcategory]

              car_manufacturer_categories = column(:car_manufacturer_category, full).compact.uniq

              if not car_manufacturer_categories.empty?
                car_manufacturer_categories.each do |car_manufacturer_category|
                  product.car_manufacturer_categories << { name: car_manufacturer_category }
                end

                car_categories = column(:car_category, full).compact.uniq

                if not car_categories.empty?
                  car_categories.each do |car_category|
                    data = find({
                      car_category: car_category
                    }, full)

                    car_manufacturer = data[:car_manufacturer_category]

                    if car_manufacturer
                      product.car_categories << { name: car_category, car_manufacturer: car_manufacturer }
                    end
                  end
                end
              end

              numbers = column(:number, full).uniq

              numbers.each do |number|
                variant = Models::Variant.new

                material = find_all({
                  number: number
                }, full)

                one = find({
                  number: number
                }, material)

                variant.number          = number
                variant.supplier_number = number
                variant.content_value   = one[:content_value]
                variant.content_unit    = one[:content_unit]
                variant.image_small     = one[:image_small]
                variant.image_big       = one[:image_big]

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