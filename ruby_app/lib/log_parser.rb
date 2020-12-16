# frozen_string_literal: true
require './lib/log_extractor'
require './lib/strategy/unique_strategy'
require './lib/strategy/all_strategy'

class LogParser
  attr_accessor :strategies, :result, :file_path

  def initialize(file_path)
    @file_path = file_path
    @strategies = [UniqueStrategy.new, AllStrategy.new]
    @result = []
  end

  def reports
    extracted_logs = LogExtractor.new(file_path).parse
    return extracted_logs[:errors] if extracted_logs[:errors].any?

    strategies.each do |strategy|
      result.push(strategy.parse(extracted_logs[:parsed_lines]))
    end

    result
  end
end
