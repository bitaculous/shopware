require 'shopware/cli/subcommands/mannol/import/models/product'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Models
            class Filter < Product
              attr_accessor :category, :subcategory

              def category=(value)
                @category = value.strip if value
              end

              def subcategory=(value)
                @subcategory = value.strip if value
              end
            end
          end
        end
      end
    end
  end
end