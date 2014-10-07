require 'validation'
require 'validation/rule/not_empty'
require 'validation/rule/numeric'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Validators
            class Oil < Validation::Validator
              include Validation

              rule :number,       :not_empty
              rule :order_number, :numeric
              rule :name,         :not_empty
              rule :description,  :not_empty
              rule :supplier,     :not_empty
              rule :properties,   :not_empty
              rule :category,     :not_empty
              rule :subcategory,  :not_empty
              rule :variants,     :not_empty
            end
          end
        end
      end
    end
  end
end