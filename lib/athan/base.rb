# frozen_string_literal: true

require_relative 'cache'
require_relative 'parser'
require 'json'
require 'colorize'

module Athan
  class Base
    attr_reader :timings, :value

    MAIN_TIMINGS = %w[Fajr Dhuhr Asr Maghrib Isha].freeze
    ADDITIONNAL_TIMINGS = %w[Sunrise Sunset Imsak Midnight].freeze
    ALL_TIMINGS = MAIN_TIMINGS + ADDITIONNAL_TIMINGS

    def initialize(payload)
      @timings = payload['data'].to_h { |day| [Date.parse(day['date']['gregorian']['date']), day['timings']] }
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
      @value.transform_values! { |timings| timings.slice(*MAIN_TIMINGS) }
      self
    end

    def pretty
      @value.map do |date, timings|
        ret = ["#{date.strftime('%B %-d, %Y').bold.light_yellow}\n"]
        ret << timings.map { |key, time| "#{key.light_green}: #{time.light_cyan}" }
        ret.join("\n")
      end.join("\n\n")
    end

    def next
      now = Time.now
      prayer, timing = get.value[Date.today].select { |_, time| now < Time.parse(time) }.shift
      "#{prayer}: #{timing}"
    end

    def as_json
      JSON.pretty_generate(@value)
    end

    def to_s(flags: 0, options: {})
      instance = self
      return instance.get.next if flags & Parser::Flags::NEXT != 0

      instance = instance.get if (flags & Parser::Flags::THREE).zero?
      instance = instance.three if flags & Parser::Flags::THREE != 0
      instance = instance.get(date: options[:date]) if flags & Parser::Flags::DATE != 0
      instance = instance.less if (flags & Parser::Flags::MORE).zero?
      flags & Parser::Flags::JSON != 0 ? instance.as_json : instance.pretty
    end

    def self.from_cache(location)
      cache = Cache.new(location)
      new(cache.value)
    end
  end

  def self.athan!
    parser = Parser.parse
    puts Base.from_cache(parser.location).to_s(flags: parser.flags, options: parser.options)
  end
end
