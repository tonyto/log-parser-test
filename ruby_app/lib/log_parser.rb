# frozen_string_literal: true
require './lib/log_extractor'

class LogParser
  attr_accessor :strategies, :result, :file_path

  def initialize(file_path)
    @file_path = file_path
    @strategies = [UniqueStrategy, AllStrategy]
    @result = []
  end

  def reports
    extracted_logs = LogExtractor.new.parse(file_path)

    strategies.each do |strategy|
      result.push(strategy.new.parse(extracted_logs[:parsed_lines]))
    end

    result
  end
end
