require 'date'

module Helpers
  def Helpers.format_unix(unix)
    Time.at(unix).utc.to_date
  end
end
