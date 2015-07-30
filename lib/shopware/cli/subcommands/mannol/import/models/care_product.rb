require 'shopware/cli/subcommands/mannol/import/models/product'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class CareProduct < Product
              attr_accessor :order_number, :description, :instruction, :small_image, :big_image, :category, :subcategory, :variants

              def initialize
                @variants = []
              end

              def category=(value)
                @category = value.strip if value
              end

              def subcategory=(value)
                @subcategory = value.strip if value
              end

              def content_options
                self.variants.map { |variant| variant.content }.compact
              end
            end
          end
        end
      end
    end
  end
end