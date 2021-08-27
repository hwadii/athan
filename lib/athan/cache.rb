# frozen_string_literal: true

require 'httparty'

module Athan
  class Cache
    include HTTParty

    attr_reader :value

    base_uri 'api.aladhan.com'

    CACHE_NAME = 'cache.json'

    def initialize(location)
      city, country = location.values_at(0, 1)
      @key = "#{city}/#{country}"
      cache_file = find_or_create_cache
      @cached_json = JSON.parse(IO.read(cache_file))
      unless @cached_json.key?(@key)
        write_cache(self.class.get('/v1/calendarByCity', { query: { city: city, country: country, method: 12 } }))
      end
      @value = @cached_json[@key]
      cache_file.close
    end

    def write_cache(to_write)
      @cached_json[@key] = JSON.parse(to_write.body)
      File.write(CACHE_NAME, JSON.fast_generate(@cached_json))
      to_write
    end

    def find_or_create_cache
      unless File.exist?(CACHE_NAME)
        File.new(CACHE_NAME, File::CREAT | File::RDWR, 0o644)
        File.write(CACHE_NAME, '{}')
      end
      File.open(CACHE_NAME)
    end
  end
end
