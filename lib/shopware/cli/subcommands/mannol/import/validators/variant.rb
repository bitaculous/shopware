require 'validation'
require 'validation/rule/not_empty'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Validators
            class Variant < Validation::Validator
              include Validation

              rule :supplier_number, :not_empty
            end
          end
        end
      end
    end
  end
end