require 'shopware/cli/subcommands/mannol/import/models/care_product'
require 'shopware/cli/subcommands/mannol/import/readers/reader'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Readers
            class CareProduct < Reader
              def care_products
                care_products = @csv[:name].uniq

                care_products.map do |name|
                  care_product name
                end
              end

              def care_product(name)
                care_product = Models::CareProduct.new

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

                care_product.name          = name
                care_product.order_number  = entity[:order_number]
                care_product.description   = entity[:description]
                care_product.instruction   = entity[:instruction]
                care_product.supplier      = entity[:supplier]

                care_product.small_image = entity[:small_image]
                care_product.big_image   = entity[:big_image]

                care_product.category    = entity[:category]
                care_product.subcategory = entity[:subcategory]

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

                  care_product.variants.push variant
                end

                care_product
              end
            end
          end
        end
      end
    end
  end
end