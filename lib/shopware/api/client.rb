require 'httparty'

module Shopware
  module API
    class Client
      include HTTParty

      headers 'Content-Type' => 'application/json', 'charset' => 'utf-8'

      format :json

      query_string_normalizer proc { |query| query.to_json }

      def initialize(options = {})
        self.class.base_uri options['base_uri']
        self.class.digest_auth options['username'], options['key']
      end

      def get_categories
        response = self.class.get '/categories'

        response['data']
      end

      def get_category(id)
        response = self.class.get "/categories/#{id}"

        response['data']
      end

      def find_category_by_name(name)
        response = self.class.get '/categories'

        if response['success']
          categories = response['data']

          categories.each do |category|
            return category if category['name'] == name
          end
        end

        nil
      end

      def create_category(properties)
        response = self.class.post '/categories', body: properties

        response['data']
      end

      def delete_category(id)
        self.class.delete "/categories/#{id}"
      end
    end
  end
end