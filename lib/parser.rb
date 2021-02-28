# frozen_string_literal: true

require 'optparse'

class Parser
  attr_reader :flags, :options

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
  end

  def parse
    OptionParser.new do |parser|
      parser.banner = 'Usage: athan [options] [location]'
      parser.on('-t', '--three', 'Get the three next days of prayer timings') do
        @flags |= FLAGS[:Three]
        abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if @flags & FLAGS[:Date] == 1
      end
      parser.on('-fDATE', '--fetch DATE', 'Fetch prayer timings for a given date') do |date|
        @flags |= FLAGS[:Date]
        abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if @flags & FLAGS[:Three] == 1
        date = begin
          Date.parse(date)
        rescue StandardError
          nil
        end
        abort 'Date is invalid. Give a valid format, e.g. YYYY-MM-DD.' if date.nil?
        @options[:date] = date
      end
      parser.on('-J', '--json', 'Get output as a json') do
        @flags |= FLAGS[:Json]
      end
      parser.on('-sSEP', '--sep SEP', 'Specify separator. Default: \'/\'') do |sep|
        @flags |= FLAGS[:Sep]
        @options[:sep] = sep
      end
      parser.on('-m', '--more', 'Display all the possible timings. Default: 5 timings.') do
        @flags |= FLAGS[:More]
      end
      parser.on('-n', '--next', 'Show next prayer timing of the day.') do
        @flags |= FLAGS[:Next]
      end
    end.parse!

    @flags |= FLAGS[:Three] if @flags.zero?
    location
  end

  private

  def location
    sep = @options[:sep] || '/'
    chunks = ARGV.first&.split(sep, 2)
    abort 'No arguments found. Aborting.' if chunks.nil?
    abort "Incorrect formatting for city and country. Expected 'City#{sep}Country'." if chunks.size != 2
    chunks
  end
end
