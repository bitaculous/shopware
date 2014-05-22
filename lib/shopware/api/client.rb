module Shopware
  module API
    class Client
      require 'httparty'
      include HTTParty

      headers 'Content-Type' => 'application/json', 'charset' => 'utf-8'

      format :json

      def initialize(options = {})
        self.class.base_uri options['base_uri']
        self.class.digest_auth options['username'], options['key']
      end

      def categories
        self.class.get '/categories'
      end
    end
  end
end