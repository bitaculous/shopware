require 'validation'
require 'validation/rule/not_empty'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          module Validators
            class Filter < Validation::Validator
              include Validation

              rule :name,     :not_empty
              rule :supplier, :not_empty
            end
          end
        end
      end
    end
  end
end