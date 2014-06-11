require 'shopware/cli/subcommands/mannol/import/models/oil'
require 'shopware/cli/subcommands/mannol/import/models/variant'
require 'shopware/cli/subcommands/mannol/import/readers/reader'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Readers
            class Oil < Reader
              def oils
                oils = @csv[:name].uniq

                oils.map do |name|
                  oil name
                end
              end

              def oil(name)
                oil = Models::Oil.new

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

                oil.number       = generate_number
                oil.name         = name
                oil.code         = entity[:code]
                oil.order_number = entity[:order_number]
                oil.description  = entity[:description]
                oil.supplier     = entity[:supplier]

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

                    oil.properties << { name: name, value: value }
                  end
                end

                oil.small_image = entity[:small_image]
                oil.big_image   = entity[:big_image]

                oil.category                = entity[:category]
                oil.subcategory             = entity[:subcategory]
                oil.subcategory_description = entity[:subcategory_description]
                oil.subsubcategory          = entity[:subsubcategory]

                car_manufacturer_categories = column(
                  key: :car_manufacturer_category,
                  data: full
                )

                if not car_manufacturer_categories.empty?
                  car_manufacturer_categories.each do |car_manufacturer_category|
                    oil.car_manufacturer_categories << { name: car_manufacturer_category }
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
                        oil.car_categories << { name: car_category, car_manufacturer: car_manufacturer }
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

                  oil.variants.push variant
                end

                oil
              end
            end
          end
        end
      end
    end
  end
end