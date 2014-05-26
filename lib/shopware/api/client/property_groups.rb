module Shopware
  module API
    class Client
      module PropertyGroups
        def get_property_groups
          response = self.class.get '/property_groups'

          response['data']
        end

        def get_property_group(id)
          response = self.class.get "/property_groups/#{id}"

          response['data']
        end

        def create_property_group(properties)
          response = self.class.post '/property_groups', body: properties

          response['data']
        end

        def update_property_group(id, properties)
          response = self.class.put "/property_groups/#{id}", body: properties

          response['data']
        end

        def delete_property_group(id)
          self.class.delete "/property_groups/#{id}"
        end
      end
    end
  end
end