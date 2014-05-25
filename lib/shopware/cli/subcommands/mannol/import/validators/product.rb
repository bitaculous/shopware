require 'validation'
require 'validation/rule/not_empty'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Validators
            class Product < Validation::Validator
              include Validation

              rule :name,         :not_empty
              rule :code,         :not_empty
              rule :order_number, :not_empty
              rule :description,  :not_empty
              rule :supplier,     :not_empty
            end
          end
        end
      end
    end
  end
end