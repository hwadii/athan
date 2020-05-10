require './lib/helpers.rb'
require 'json'
require 'colorize'

class Athan
  def initialize(payload)
    @timings = payload['data'].to_h { |day| [Helpers.format_unix(day['date']['timestamp'].to_i), day['timings']] }
    @obj = nil
  end

  def today
    @obj = { Date.today => @timings.fetch(Date.today) }
    self
  end

  def yesterday
    @obj = { Date.today.prev_day => @timings.fetch(Date.today.prev_day) }
    self
  end

  def tomorrow
    @obj = { Date.today.next => @timings.fetch(Date.today.next) }
    self
  end

  def three
    @obj = {
      Date.today.prev_day => @timings.fetch(Date.today.prev_day),
      Date.today => @timings.fetch(Date.today),
      Date.today.next => @timings.fetch(Date.today.next),
    }
    self
  end

  def less
    to_remove = %w[Sunrise Sunset Imsak Midnight]
    @obj.transform_values! { |timings| timings.select { |key| !to_remove.include?(key) } }
    self
  end

  def pretty
    @obj.map do |date, timings|
      ret = ["#{date.strftime("%B %-d, %Y").light_yellow}\n"]
      ret << timings.map { |key, time| "#{key.light_green}: #{time.light_cyan}" }
      ret.join("\n")
    end.join("\n\n")
  end

  def timings
    @timings
  end

  def debug
    JSON.pretty_generate(@obj)
  end
end
