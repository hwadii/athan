require 'optparse'

class Parser
  def initialize
    @options = {}
  end

  def parse
    OptionParser.new do |parser|
      parser.on('-t', '--three', 'Get the three next days of prayer timings') do
        @options[:three] = true
        abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if @options.key?(:fetch)
      end
      parser.on('-J', '--json', 'Get output as a json') do
        @options[:json] = true
      end
      parser.on('-fDATE', '--fetch DATE', 'Fetch prayer timings for a given date') do |date|
        date = Date.parse(date) rescue nil
        abort '-t (three) and -f (fetch) are mutually exclusive. Use one or the other.' if @options.key?(:three)
        abort 'Date is invalid. Give a valid format, e.g. YYYY-MM-DD.' if date.nil?
        @options[:fetch] = date
      end
      parser.on('-sSEP', '--sep SEP', 'Specify separator. Default: \'/\'') do |sep|
        @options[:sep] = sep
      end
      parser.on('-m', '--more', 'Display all the possible timings. Default: 5 timings.') do
        @options[:more] = true
      end
    end.parse!
    city, country = get_location
    @options[:city] = city
    @options[:country] = country
    @options
  end

  private

  def get_location
    sep = @options[:sep] || '/'
    chunks = ARGV.first&.split(sep, 2)
    abort 'Incorrect formatting for city and country. Expected \'City/Country\'.' if chunks&.size < 2
    chunks
  end
end
