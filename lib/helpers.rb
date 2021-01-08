require 'date'

module Helpers
  CACHE_NAME = 'cache.json'.freeze

  def format_unix(unix)
    Time.at(unix).utc.to_date
  end

  def find_or_create_cache
    File.new(CACHE_NAME, File::CREAT | File::RDWR, 0o644) unless File.exist?(CACHE_NAME)
    File.open(CACHE_NAME)
  end
end
