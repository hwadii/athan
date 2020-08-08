require 'httparty'

CACHE_NAME = 'cache.json'

class GetAthan
  include HTTParty
  base_uri 'api.aladhan.com'

  def initialize(city: nil, country: nil)
    @options = { query: { city: city, country: country, method: 12 } }
    @key = "#{city}/#{country}"
    if !File.exist?(CACHE_NAME)
      File.new(CACHE_NAME, File::CREAT | File::RDWR, 0644)
    end
    file = File.open(CACHE_NAME)
    @cache = JSON.load(file) || Hash.new(0)
    file.close
  end

  def make_request
    if check_cache
      @cache[@key]
    else
      write_cache(self.class.get('/v1/calendarByCity', @options))
    end
  end

  def produce
    Athan.new(make_request)
  end

  def write_cache(to_write)
    return if to_write.body.nil?
    @cache[@key] = JSON.load(to_write.body)
    File.write(CACHE_NAME, JSON.fast_generate(@cache))
    to_write
  end

  def check_cache
    @cache.key?(@key)
  end
end
