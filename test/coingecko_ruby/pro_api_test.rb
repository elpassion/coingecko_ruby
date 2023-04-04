require 'test_helper'

class ProApiError < Minitest::Test
  def setup
    @client = CoingeckoRuby::Client.new(pro_api_key: 'COINGECKO_PRO_API_KEY')
  end

  def test_that_it_uses_pro_base_url_and_sets_pro_headers
    stub_request(:any, "https://pro-api.coingecko.com/api/v3/stubbed_endpoint")

    @client.get('stubbed_endpoint')

    assert_requested :get, "https://pro-api.coingecko.com/api/v3/stubbed_endpoint",
      headers: {'x-cg-pro-api-key' => 'COINGECKO_PRO_API_KEY'},
      times: 1
  end
end
