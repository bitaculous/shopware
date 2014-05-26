module Shopware
  module CLI
    module Subcommands
      module PropertyGroups
        module Delete
          def self.included(thor)
            thor.class_eval do
              desc 'delete ID', 'Delete property group with ID'
              def delete(id)
                result = @client.delete_property_group id

                if result['success']
                  ok 'Property group delete.'
                else
                  error 'Property group could not be deleted.'
                end
              end
            end
          end
        end
      end
    end
  end
end