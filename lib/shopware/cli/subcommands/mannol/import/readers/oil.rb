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
              SPEC_SUBCATEGORIES_SPLIT_CHARACTER = '/'

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

                    unit = data[:property_unit]

                    value = "#{value} #{unit}" if unit

                    oil.properties << { name: name, value: value }
                  end
                end

                oil.small_image = entity[:small_image]
                oil.big_image   = entity[:big_image]

                oil.category                = entity[:category]
                oil.subcategory             = entity[:subcategory]
                oil.subcategory_description = entity[:subcategory_description]
                oil.subsubcategory          = entity[:subsubcategory]

                spec_categories = column(
                  key: :spec_category,
                  data: full
                )

                if not spec_categories.empty?
                  spec_categories.each do |spec_category|
                    spec_category = spec_category.to_s.strip

                    oil.spec_categories << { name: spec_category }
                  end

                  spec_subcategories = column(
                    key: :spec_subcategory,
                    data: full
                  )

                  if not spec_subcategories.empty?
                    spec_subcategories.each do |spec_subcategory|
                      data = find(
                        criterions: {
                          spec_subcategory: spec_subcategory
                        },
                        data: full
                      )

                      spec_category = data[:spec_category]

                      if spec_category
                        spec_subcategory = data[:spec_subcategory].to_s.strip

                        partials = spec_subcategory.split SPEC_SUBCATEGORIES_SPLIT_CHARACTER

                        partials.each do |partial|
                          partial = partial.to_s.strip

                          oil.spec_subcategories << { name: partial, spec_category: spec_category }
                        end
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