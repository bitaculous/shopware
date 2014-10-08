require 'validation'
require 'validation/rule/not_empty'
require 'validation/rule/numeric'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Validators
            class Variant < Validation::Validator
              include Validation

              rule :supplier_number, :numeric
            end
          end
        end
      end
    end
  end
end