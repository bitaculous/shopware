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
                content_unit ? "#{content_value} #{shopware_unit content_unit}" : content_value
              end

              def shopware_unit(unit)
                case unit
                when 'L'
                  'Liter'
                when 'Kg'
                  'Kilogramm'
                when 'g'
                  'Gramm'
                else
                  unit
                end
              end
            end
          end
        end
      end
    end
  end
end