#!/usr/bin/env ruby

require 'date'
require 'json'
require './lib/athan.rb'
require './lib/cache.rb'

raw_payload = GetAthan.new(city: 'Marseille', country: 'France')
athan = raw_payload.produce
puts athan.today.pretty

