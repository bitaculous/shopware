module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Product
              attr_accessor :code, :order_number, :name, :description, :supplier, :variants

              def initialize
                @variants = []
              end
            end
          end
        end
      end
    end
  end
end