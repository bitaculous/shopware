module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Variant
              attr_accessor :number, :supplier_number, :properties, :image_small, :image_big, :category, :subcategory, :subcategory_description, :subsubcategory, :car_categories

              def initialize
                @properties = []

                @car_categories = []
              end
            end
          end
        end
      end
    end
  end
end