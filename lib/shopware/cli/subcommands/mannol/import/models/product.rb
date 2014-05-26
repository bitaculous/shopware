module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Product
              attr_accessor :number, :code, :order_number, :name, :description,
                            :supplier, :variants

              def initialize
                @variants = []
              end

              def content_options
                @variants.map { |variant| variant.content }
              end
            end
          end
        end
      end
    end
  end
end