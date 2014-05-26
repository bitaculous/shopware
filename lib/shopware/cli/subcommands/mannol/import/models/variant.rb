module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Variant
              attr_accessor :number, :supplier_number, :content_value, :content_unit,
                            :properties, :image_small, :image_big, :category,
                            :subcategory, :subcategory_description, :subsubcategory,
                            :car_categories

              def initialize
                @properties = []

                @car_categories = []
              end

              def content
                content_unit ? "#{content_value} #{content_unit}" : content_value
              end
            end
          end
        end
      end
    end
  end
end