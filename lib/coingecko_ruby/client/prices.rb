module CoingeckoRuby
  class Client
    module Prices
      # Fetches the current price for a coin in the given coin or currency.
      # @param ids [String] the coin id to fetch.
      # @param currencies [String] the currency to display the coin's price.
      #
      # @return [Hash] returns the given coin id and its current price.
      #
      # @example Fetch the current price in USD for Bitcoin.
      #   client.get_prices(ids: 'bitcoin', currencies: 'usd')
      def get_prices(ids:, currencies: 'usd')
        get('simple/price', { query: { ids: ids, vs_currencies: currencies } })
      end

      # Fetches historical price data for a coin at a given date.
      # @param id [String] the coin id to fetch.
      # @param date [String] the date to fetch the historical price, date given must be in the form of 'DD-MM-YYYY' (e.g: '14-05-2021').
      #
      # @return [Hash] returns the coin's historical price data on the given date.
      #
      # @example Fetch Bitcoin's price on 30th December, 2017.
      #   client.get_historical_price_on_date(id: 'bitcoin', date: '30-12-2017')
      def get_historical_price_on_date(id:, date:)
        get("coins/#{id}/history", { query: { date: date } })
      end

      # Fetches a coin's historical price data in 5 - 10 minutes ranges.
      # @note Minutely historical data is only available within the last 24 hours.
      # @param id [String] the coin id to fetch.
      #
      # @return [Hash] returns the coin's minutely historical price data within the last 24 hours.
      #
      # @example Fetch Bitcoin's minutely historical price within the last 24 hours.
      #   client.get_minutely_historical_prices(id: 'bitcoin')
      def get_minutely_historical_prices(id:, currency: 'usd')
        get("coins/#{id}/market_chart", { query: { vs_currency: currency, days: 1 } })
      end

      # Fetches a coin's historical price data in 1 hour ranges.
      # @note Hourly historical data is only available within the last 90 days.
      # @param id [String] the coin id to fetch.
      # @param days [Integer] the number of days to fetch hourly historical prices.
      #
      # @return [Hash] returns the coin's hourly historical price data within the number of days given.
      #
      # @example Fetch Bitcoin's hourly historical price within the last 60 days.
      #   client.get_hourly_historical_prices(id: 'bitcoin', days: 60)
      def get_hourly_historical_prices(id:, days:, currency: 'usd')
        return get_daily_historical_prices(id: id, days: days) if days > 90

        get("coins/#{id}/market_chart", { query: { vs_currency: currency, days: days } })
      end

      # Fetches a coin's historical price data in daily ranges.
      # @param id [String] the coin id to fetch.
      # @param days [Integer] the number of days to fetch daily historical prices.
      #
      # @return [Hash] returns the coin's daily historical price data within the number of days given.
      #
      # @example Fetch Bitcoin's daily historical price within the last 60 days.
      #   client.get_daily_historical_prices(id: 'bitcoin', days: 90)
      def get_daily_historical_prices(id:, days:, currency: 'usd')
        get("coins/#{id}/market_chart", { query: { vs_currency: currency, days: days, interval: 'daily' } })
      end

      # Fetches a coin's open, high, low, and close (OHLC) data within the number of days given.
      # @param id [String] the coin id to fetch.
      # @param days [Integer, String] the number of days to fetch daily historical prices. Only accepts the following values: 1/7/14/30/90/180/365/'max'
      # @param currency [String] the currency to display OHLC data.
      #
      # @return [Array<Array<String, Float>>] returns the coin's OHLC data within the number of days given.
      #
      # @example Fetch Bitcoin's OHLC data within the last 7 days.
      #   client.get_ohlc(id: 'bitcoin', days: 7)
      # @example Fetch Bitcoin's OHLC data in Malaysian Ringgit within the last 30 days.
      #   client.get_ohlc(id: 'bitcoin', days: 30, currency: 'myr')
      def get_ohlc(id:, days:, currency: 'usd')
        get("coins/#{id}/ohlc", { query: { vs_currency: currency, days: days } })
      end

      # Fetches the list of currencies currently supported by CoinGecko's API.
      #
      # @return [Array<String>] returns the list of currencies currently supported by CoinGecko's API.
      #
      # @example Fetch supported currencies.
      #   client.supported_currencies
      def supported_currencies
        get('simple/supported_vs_currencies')
      end

      # Fetches the exchange rate for a coin or currency in the given coin or currency.
      # @param from [String] the coin id or currency to be converted.
      # @param to [String] the coin id or currency to convert against.
      #
      # @return [Hash] returns the coin's exchange rate against the given coin or currency.
      #
      # @example Fetch the exchange rate for BTC-USD.
      #   client.get_exchange_rate(from: 'bitcoin', to: 'usd')
      # @example Fetch the exchange rate for BTC-ETH.
      #   client.get_exchange_rate(from: 'bitcoin', to: 'ethereum')
      def get_exchange_rate(from:, to: 'usd')
        get_prices(ids: from, currencies: to)
      end
    end
  end
end
