require 'date'

module Helpers
  CACHE_NAME = 'cache.json'
  OPTIONS_NAME = %i[json three fetch more].freeze

  def format_unix(unix)
    Time.at(unix).utc.to_date
  end

  def find_or_create_cache
    if !File.exist?(CACHE_NAME)
      File.new(CACHE_NAME, File::CREAT | File::RDWR, 0644)
    end
    File.open(CACHE_NAME)
  end
end
