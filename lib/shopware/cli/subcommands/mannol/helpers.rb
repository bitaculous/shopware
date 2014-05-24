require 'pp'

module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Helpers
          def self.included(thor)
            thor.class_eval do
              desc 'create_base_product', 'Create base product'
              def create_base_product
                puts 'Hello'
              end
            end
          end
        end
      end
    end
  end
end