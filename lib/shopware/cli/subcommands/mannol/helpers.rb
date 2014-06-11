module Shopware
  module CLI
    module Subcommands
      module Mannol
        module Helpers
          def self.included(thor)
            thor.class_eval do
              desc 'create_oil_property_group', 'Create oil property group'
              option :name, type: :string, default: 'Öl'
              option :position, type: :numeric, default: 0
              option :comparable, type: :boolean, default: true
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