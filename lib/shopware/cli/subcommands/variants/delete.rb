module Shopware
  module CLI
    module Subcommands
      module Variants
        module Delete
          def self.included(thor)
            thor.class_eval do
              desc 'delete ID', 'Delete variant with ID'
              def delete(id)
                result = @client.delete_variant id

                if result['success']
                  ok 'Variant delete.'
                else
                  error 'Variant could not be deleted.'
                end
              end
            end
          end
        end
      end
    end
  end
end