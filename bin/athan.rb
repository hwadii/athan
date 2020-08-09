#!/usr/bin/env ruby

require 'date'
require 'json'
require_relative '../lib/athan'
require_relative '../lib/cache'
require_relative '../lib/parser'

args = Parser.new.parse
raw_payload = Cache.new(city: args[:city], country: args[:country])
athan = raw_payload.produce
$stdout.print Athan.build_method(athan: athan, args: args.slice(*Helpers::OPTIONS_NAME)) + "\n"
