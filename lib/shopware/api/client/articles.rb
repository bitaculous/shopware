module Shopware
  module API
    class Client
      module Articles
        def get_articles
          response = self.class.get '/articles'

          response['data']
        end

        def get_article(id)
          response = self.class.get "/articles/#{id}"

          response['data']
        end

        def find_article_by_name(name)
          filter = "filter[0][property]=name&filter[0][expression]=%3D&filter[0][value]=#{name}"
          response = self.class.get '/articles', { query: filter }
          
          response['data'].empty? ? nil : response['data'].first
        end

        def create_article(properties)
          response = self.class.post '/articles', body: properties

          response['data']
        end

        def update_article(id, properties)
          response = self.class.put "/articles/#{id}", body: properties

          response['data']
        end

        def delete_article(id)
          self.class.delete "/articles/#{id}"
        end
      end
    end
  end
end
