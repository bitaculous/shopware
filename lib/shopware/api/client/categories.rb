module Shopware
  module API
    class Client
      module Categories
        def get_categories
          response = self.class.get '/categories'

          response['data']
        end

        def get_category(id)
          response = self.class.get "/categories/#{id}"

          response['data']
        end

        def find_category_by_name(name)
          filter   = "filter[0][property]=name&filter[0][expression]=%3D&filter[0][value]=#{name}"
          response = self.class.get '/categories', { query: filter }

          response['data'].empty? ? nil : response['data'].first
        end

        def create_category(properties)
          response = self.class.post '/categories', body: properties

          response['data']
        end

        def update_category(id, properties)
          response = self.class.put "/categories/#{id}", body: properties

          response['data']
        end

        def delete_category(id)
          self.class.delete "/categories/#{id}"
        end
      end
    end
  end
end