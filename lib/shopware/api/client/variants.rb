module Shopware
  module API
    class Client
      module Variants
        def get_variant(id)
          response = self.class.get "/variants/#{id}"

          response['data']
        end

        def create_variant(properties)
          response = self.class.post '/variants', body: properties

          response['data']
        end

        def update_variant(id, properties)
          response = self.class.put "/variants/#{id}", body: properties

          response['data']
        end

        def delete_variant(id)
          self.class.delete "/variants/#{id}"
        end
      end
    end
  end
end