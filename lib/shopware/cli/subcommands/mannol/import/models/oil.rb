require 'shopware/cli/subcommands/mannol/import/models/product'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Oil < Product
              attr_accessor :code, :order_number, :description, :properties, :small_image, :big_image,
                            :category, :subcategory, :subcategory_description, :subsubcategory,
                            :spec_categories, :spec_subcategories, :variants

              def initialize
                @properties, @spec_categories, @spec_subcategories, @variants = [], [], [], []
              end

              def category=(value)
                @category = value.strip if value
              end

              def subcategory=(value)
                @subcategory = value.strip if value
              end

              def subcategory_description=(value)
                @subcategory_description = value.strip if value
              end

              def subsubcategory=(value)
                @subsubcategory = value.strip if value
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