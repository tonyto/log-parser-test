#!/usr/bin/env ruby

require './lib/log_parser'

if ARGV.length != 1
  puts 'Please specify a file to parse.'
  exit;
end

filename = ARGV[0]
puts "Reading file: #{filename}"

log_parser = LogParser.new(filename)
log_parser.reports.map do |report|
  $stdout.puts report.name
  $stdout.puts report.output
end

