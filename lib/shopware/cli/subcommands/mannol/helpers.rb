module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Helpers
          def self.included(thor)
            thor.class_eval do
              desc 'create_base_article', 'Create a base article'
              option :name, type: :string, default: 'Öl'
              option :supplier, type: :string, default: 'MANNOL'
              option :number, type: :string, default: '00000000001'

              def create_base_article
                properties = {
                  name: options.name,
                  supplier: options.supplier,
                  tax: 19,
                  mainDetail: {
                    number: options.number,
                    prices: [
                      {
                        customerGroupKey: 'EK',
                        price: 0
                      }
                    ]
                  },
                  configuratorSet: {
                    groups: [
                      {
                        name: 'Inhalt'
                      }
                    ]
                  }
                }

                article = @client.create_article properties

                if article
                  ok 'Article created.'
                else
                  error 'Uuuuuppppss, something went wrong.'
                end
              end
            end
          end
        end
      end
    end
  end
end