require 'faraday'
require 'faraday_middleware'
require 'coingecko_ruby/error'

module CoingeckoRuby
  module Connection
    BASE_URL = 'https://api.coingecko.com/api/v3/'.freeze
    PRO_BASE_URL = 'https://pro-api.coingecko.com/api/v3/'.freeze

    def get(endpoint, **opts)
      request :get, endpoint, **opts
    end

    def request(method, endpoint, **opts)
      connection = create_connection
      response = connection.send(method, endpoint, opts)
      response.body
    rescue Faraday::Error => e
      wrapped_error_class = CoingeckoRuby::FaradayError.wrap_error(e)
      raise wrapped_error_class.new(e.message, response)
    end

    def create_connection
      url, headers = BASE_URL, {}
      if @pro_api_key
        url = PRO_BASE_URL
        headers['x-cg-pro-api-key'] = @pro_api_key
      end

      connection = Faraday.new(url: url, headers: headers) do |c|
        c.use Faraday::Response::RaiseError
        c.request :retry, max: 5
        c.response :json
      end
      connection
    end
  end
end
