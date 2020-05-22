require 'date'
require 'json'
require './lib/athan.rb'
require './lib/helpers.rb'

file = File.open './paris.json'
response = JSON.load(file)
file.close

athan = Athan.new(response)
puts athan.today.pretty

