module Shopware
  module CLI
    module Subcommands
      module Categories
        module Delete
          def self.included(thor)
            thor.class_eval do
              desc 'delete ID', 'Delete category with ID'
              def delete(id)
                result = @client.delete_category id

                if result['success']
                  ok 'Category delete.'
                else
                  error 'Category could not be deleted.'
                end
              end
            end
          end
        end
      end
    end
  end
end