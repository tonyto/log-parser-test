# frozen_string_literal: true
require './lib/strategy/base_strategy'
require './lib/strategy/report'

class UniqueStrategy < BaseStrategy
  def parse(parsed_lines)
    output = ''
    parsed_lines
      .sort_by{|k, v| v.uniq.length }
      .reverse
      .each{|k, v| output += format_output(k, v)}

    Report.new(self.class, output)
  end

  private

  def format_output(key, value)
    unique_value = value.uniq

    if unique_value.length > 1
      "#{key} #{unique_value.length} unique views\n"
    else
      "#{key} #{unique_value.length} unique view\n"
    end
  end
end
