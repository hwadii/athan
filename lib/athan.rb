require_relative 'helpers'
require 'json'
require 'colorize'

class Athan
  extend Helpers

  attr_reader :timings, :value

  def initialize(payload)
    @timings = payload['data'].to_h { |day| [self.class.format_unix(day['date']['timestamp'].to_i), day['timings']] }
    @value = nil
  end

  def get(date: Date.today)
    @value = { date => @timings.fetch(date) }
    self
  end

  def tomorrow
    get(date: Date.today.next)
    self
  end

  def three
    @value = @timings.slice(Date.today, Date.today.next, Date.today.next.next)
    self
  end

  def less
    all_keys = %w[Fajr Sunrise Dhuhr Asr Sunset Maghrib Isha Imsak Midnight]
    to_remove = %w[Sunrise Sunset Imsak Midnight]
    @value.transform_values! { |timings| timings.slice(*all_keys - to_remove) }
    self
  end

  def pretty
    @value.map do |date, timings|
      ret = ["#{date.strftime("%B %-d, %Y").light_yellow}\n"]
      ret << timings.map { |key, time| "#{key.light_green}: #{time.light_cyan}" }
      ret.join("\n")
    end.join("\n\n")
  end

  def next
    now = Time.now
    prayer, timing = self.class.of(athan: less).select { |_, time| now < Time.parse(time) }.shift
    "#{prayer}: #{timing}"
  end

  def as_json
    JSON.pretty_generate(@value)
  end

  def self.of(athan: nil, date: Date.today)
    athan.value[date] unless athan.nil?
  end

  def self.build_method(athan: nil, args: nil)
    return if athan.nil?

    call = athan.get
    return call.next if args.key?(:next)
    args.each do |key, value|
      case key
      when :three
        call = call.three
      when :fetch
        call = call.get(value)
      end
    end
    call = call.less unless args.key?(:more)
    args.key?(:json) ? call.as_json : call.pretty
  end
end
