module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Variant
              attr_accessor :number, :supplier_number, :content_value, :content_unit, :small_image, :big_image

              def content
                content_value = self.content_value
                content_unit  = self.content_unit

                content_unit ? "#{content_value} #{convert_unit content_unit}" : content_value if content_value
              end

              def purchase_unit
                content_value = self.content_value

                content_value.to_f if content_value
              end

              def reference_unit
                1.to_f
              end

              def unit_id
                case self.content_unit
                when 'L'
                  1
                when 'g'
                  2
                when 'Kg'
                  6
                when 'ml'
                  10
                end
              end

              private

              def convert_unit(unit)
                case unit
                when 'L'
                  'Liter'
                when 'g'
                  'Gramm'
                when 'Kg'
                  'Kilogramm'
                when 'ml'
                  'Milliliter'
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