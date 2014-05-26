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

              desc 'create_oil_property_group', 'Create oil property group'
              option :name, type: :string, default: 'Öl'
              option :position, type: :numeric, default: 1
              option :comparable, type: :numeric, default: 1
              option :sort_mode, type: :numeric, default: 2

              def create_oil_property_group
                properties = {
                  name: options.name,
                  position: options.position,
                  comparable: options.comparable,
                  sortMode: options.sort_mode
                }

                property_group = @client.create_property_group properties

                if property_group
                  ok 'Property group created.'
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