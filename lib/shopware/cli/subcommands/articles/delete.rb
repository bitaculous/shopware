module Shopware
  module CLI
    module Subcommands
      module Articles
        module Delete
          def self.included(thor)
            thor.class_eval do
              desc 'delete ID', 'Delete article with ID'
              def delete(id)
                result = @client.delete_article id

                if result['success']
                  ok 'Article delete.'
                else
                  error 'Article could not be deleted.'
                end
              end
            end
          end
        end
      end
    end
  end
end