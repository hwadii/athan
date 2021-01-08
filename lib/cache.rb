require 'httparty'
require_relative 'helpers'

class Cache
  include HTTParty
  include Helpers

  base_uri 'api.aladhan.com'

  def initialize(city: nil, country: nil)
    @options = { query: { city: city, country: country, method: 12 } }
    @key = "#{city}/#{country}"
    cache_file = find_or_create_cache
    @cache = JSON.parse(IO.read(cache_file)) || Hash.new(0)
    cache_file.close
  end

  def make_request_or_get_cache
    if check_cache
      @cache[@key]
    else
      write_cache(self.class.get('/v1/calendarByCity', @options))
    end
  end

  def produce
    Athan.new(make_request_or_get_cache)
  end

  def write_cache(to_write)
    return if to_write.body.nil?

    @cache[@key] = JSON.parse(to_write.body)
    File.write(CACHE_NAME, JSON.fast_generate(@cache))
    to_write
  end

  def check_cache
    @cache.key?(@key)
  end
end
