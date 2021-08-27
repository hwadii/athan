# frozen_string_literal: true

require_relative 'location'
require 'optparse'

module Athan
  class Parser
    attr_accessor :flags, :options, :location

    FLAGS = {
      Three: 0b00_0001,
      Json: 0b00_0010,
      Date: 0b00_0100,
      Sep: 0b00_1000,
      More: 0b01_0000,
      Next: 0b10_0000
    }.freeze

    def initialize
      @flags = 0
      @options = {
        sep: nil,
        date: nil
      }.compact
      @location = nil
    end

    def self.parse
      parser = new

      OptionParser.new do |p|
        p.banner = 'Usage: athan [options] [location]'
        p.on('-t', '--three', 'Get the three next days of prayer timings') do
          parser.flags |= FLAGS[:Three]
          abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if parser.flags & FLAGS[:Date] == 1
        end
        p.on('-fDATE', '--fetch DATE', 'Fetch prayer timings for a given date') do |date|
          parser.flags |= FLAGS[:Date]
          abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if parser.flags & FLAGS[:Three] == 1
          date = begin
            Date.parse(date)
          rescue StandardError
            nil
          end
          abort 'Date is invalid. Give a valid format, e.g. YYYY-MM-DD.' unless date
          parser.options[:date] = date
        end
        p.on('-J', '--json', 'Get output as a json') do
          parser.flags |= FLAGS[:Json]
        end
        p.on('-sSEP', '--sep SEP', 'Specify separator. Default: \'/\'') do |sep|
          parser.flags |= FLAGS[:Sep]
          parser.options[:sep] = sep
        end
        p.on('-m', '--more', 'Display all the possible timings. Default: 5 timings.') do
          parser.flags |= FLAGS[:More]
        end
        p.on('-n', '--next', 'Show next prayer timing of the day.') do
          parser.flags |= FLAGS[:Next]
        end
      end.parse!

      parser.flags |= FLAGS[:Three] if parser.flags.zero?

      sep = parser.options[:sep] || '/'
      chunks = ARGV.first&.split(sep, 2)
      abort 'No arguments found. Aborting.' if chunks.nil?
      abort "Incorrect formatting for city and country. Expected 'City#{sep}Country'." if chunks.size != 2
      parser.location = Location.new(*chunks)

      parser
    end
  end
end
