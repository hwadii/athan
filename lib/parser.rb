require 'optparse'

class Parser
  def initialize
    @options = {}
  end

  def parse
    OptionParser.new do |parser|
      parser.on('-cCITY', '--city CITY', 'Provide a city') do |city|
        @options[:city] = city
      end
      parser.on('-dCOUNTRY', '--country COUNTRY', 'Provide a country') do |country|
        @options[:country] = country
      end
    end.parse!
    check_args
    @options
  end

  private

  def check_args
    if !@options.key?(:city)
      raise OptionParser::MissingArgument, 'Missing parameter: city'
      exit 1
    end

    if !@options.key?(:country)
      raise OptionParser::MissingArgument, 'Missing parameter: country'
      exit 1
    end
  end
end
