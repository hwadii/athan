require_relative 'helpers'
require 'json'
require 'colorize'

class Athan
  extend Helpers

  def initialize(payload)
    @timings = payload['data'].to_h { |day| [self.class.format_unix(day['date']['timestamp'].to_i), day['timings']] }
    @value = nil
  end

  def get(date = Date.today)
    @value = { date => @timings.fetch(date) }
    self
  end

  def today
    @value = { Date.today => @timings.fetch(Date.today) }
    self
  end

  def yesterday
    @value = { Date.today.prev_day => @timings.fetch(Date.today.prev_day) }
    self
  end

  def tomorrow
    @value = { Date.today.next => @timings.fetch(Date.today.next) }
    self
  end

  def three
    @value = {
      Date.today => @timings.fetch(Date.today),
      Date.today.next => @timings.fetch(Date.today.next),
      Date.today.next.next => @timings.fetch(Date.today.next.next),
    }
    self
  end

  def less
    to_remove = %w[Sunrise Sunset Imsak Midnight]
    @value.transform_values! { |timings| timings.select { |key| !to_remove.include?(key) } }
    self
  end

  def pretty
    @value.map do |date, timings|
      ret = ["#{date.strftime("%B %-d, %Y").light_yellow}\n"]
      ret << timings.map { |key, time| "#{key.light_green}: #{time.light_cyan}" }
      ret.join("\n")
    end.join("\n\n")
  end

  def timings
    @timings
  end

  def as_json
    JSON.pretty_generate(@value)
  end
end
