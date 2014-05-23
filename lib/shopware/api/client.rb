require 'httparty'

require 'shopware/api/client/categories'

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

      include Categories
    end
  end
end