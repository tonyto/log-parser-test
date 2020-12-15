# frozen_string_literal: true

class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    begin
      File.foreach(@file_path) do |line|
        if valid_line?(line)
          url, ip = line.split(' ')
          result[url] ? result[url] << ip : result[url] = [ip]
        else
          errors.push('invalid line')
        end
      end
    rescue => err
      errors.push(StandardError.new('error'))
    end
  end

  def errors
    @errors ||= []
  end

  def result
    @result ||= Hash.new
  end

  def parse_all
    output = ''

    result.each{|k, v| output += format_output(k, v)}

    output
  end

  def parse_unique
    output = ''

    result.each{|k, v| output += format_unique_output(k, v)}

    output
  end

  private

  def valid_line?(line)
    line.split(' ').length == 2
  end

  def format_unique_output(key, value)
    unique_value = value.uniq
    unique_value.length > 1 ? "#{key} #{unique_value.length} unique views\n" : "#{key} #{unique_value.length} unique view\n"
  end

  def format_output(key, value)
    value.length > 1 ? "#{key} #{value.length} visits\n" : "#{key} #{value.length} visit\n"
  end
end