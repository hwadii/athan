# frozen_string_literal: true

require_relative 'location'
require 'optparse'

module Athan
  class Parser
    attr_accessor :flags, :options, :location

    Options = Struct.new(:sep, :date)

    module Flags
      THREE = 1 << 0
      JSON = 1 << 1
      DATE = 1 << 2
      SEP = 1 << 3
      MORE = 1 << 4
      NEXT = 1 << 5
    end

    def initialize
      @flags = 0
      @options = Options.new
      @location = nil
    end

    def self.parse
      parser = new

      OptionParser.new do |p|
        p.banner = 'Usage: athan [options] [location]'
        p.on('-t', '--three', 'Get the three next days of prayer timings') do
          parser.flags |= Flags::THREE
          abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if parser.flags & Flags::DATE == 1
        end
        p.on('-fDATE', '--fetch DATE', 'Fetch prayer timings for a given date') do |date|
          parser.flags |= Flags::DATE
          abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if parser.flags & Flags::THREE == 1
          date = begin
            Date.parse(date)
          rescue StandardError
            nil
          end
          abort 'Date is invalid. Give a valid format, e.g. YYYY-MM-DD.' unless date
          parser.options.date = date
        end
        p.on('-J', '--json', 'Get output as a json') do
          parser.flags |= Flags::JSON
        end
        p.on('-sSEP', '--sep SEP', 'Specify separator. Default: \'/\'') do |sep|
          parser.flags |= Flags::SEP
          parser.options.sep = sep
        end
        p.on('-m', '--more', 'Display all the possible timings. Default: 5 timings.') do
          parser.flags |= Flags::MORE
        end
        p.on('-n', '--next', 'Show next prayer timing of the day.') do
          parser.flags |= Flags::NEXT
        end
      end.parse!

      sep = parser.options.sep || '/'
      chunks = ARGV.first&.split(sep, 2)
      abort 'No arguments found. Aborting.' if chunks.nil?
      abort "Incorrect formatting for city and country. Expected 'City#{sep}Country'." if chunks.size != 2
      parser.location = Location.new(*chunks)

      parser
    end
  end
end
