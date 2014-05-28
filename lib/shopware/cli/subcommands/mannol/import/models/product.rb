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
                @properties = []

                @car_manufacturer_categories = []

                @car_categories = []

                @variants = []
              end

              def content_options
                @variants.map { |variant| variant.content }.compact
              end
            end
          end
        end
      end
    end
  end
end