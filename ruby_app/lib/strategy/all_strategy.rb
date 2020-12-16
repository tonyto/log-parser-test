# frozen_string_literal: true
require './lib/strategy/base_strategy'
require './lib/strategy/report'

class AllStrategy < BaseStrategy
  def parse(parsed_lines)
    output = ''
    parsed_lines.each{|k, v| output += format_output(k, v)}

    Report.new(self.class, output)
  end

  private

  def format_output(key, value)
    if value.length > 1
      "#{key} #{value.length} visits\n"
    else
      "#{key} #{value.length} visit\n"
    end
  end
end