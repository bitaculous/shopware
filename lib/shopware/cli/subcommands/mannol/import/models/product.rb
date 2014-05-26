module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Product
              attr_accessor :number, :code, :order_number, :name, :description, :supplier, :variants

              def initialize
                @variants = []
              end

              def all_properties
                result = []

                @variants.each do |variant|
                  properties = variant.properties

                  properties.each do |property|
                    label = property[:label]
                    value = property[:value]

                    if result.any? { |element| element[:label] == label }
                      element = result.find { |element| element[:label] == label }
                      values = element[:values]

                      values << value if not values.include? value
                    else
                      result << { label: label, values: [value] }
                    end
                  end
                end

                result
              end
            end
          end
        end
      end
    end
  end
end