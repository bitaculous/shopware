require 'validation'
require 'validation/rule/not_empty'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Import
          class Validator < Validation::Validator
            include Validation

            rule :category, :not_empty
            rule :brand,    :not_empty
          end
        end
      end
    end
  end
end