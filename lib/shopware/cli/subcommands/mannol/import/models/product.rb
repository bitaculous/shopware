module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Product
              attr_accessor :number, :code, :order_number, :name, :description, :supplier, :properties, :small_image,
                            :big_image, :category, :subcategory, :subcategory_description, :subsubcategory,
                            :car_manufacturer_categories, :car_categories, :variants

              def initialize
                @properties, @car_manufacturer_categories, @car_categories, @variants = [], [], [], []
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

              def car_manufacturer_categories=(value)
                @car_manufacturer_categories = value.strip if value
              end

              def car_categories=(value)
                @car_categories = value.strip if value
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