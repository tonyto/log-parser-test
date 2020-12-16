# frozen_string_literal: true

class LogExtractor
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    begin
      File.foreach(@file_path) do |line|
        if valid_line?(line)
          read_line(line)
        else
          errors.push('invalid line')
        end
      end
    rescue => err
      errors.push(StandardError.new('error'))
    end

    { parsed_lines: parsed_lines, errors: errors }
  end

  def errors
    @errors ||= []
  end

  private

  def parsed_lines
    @parsed_lines ||= Hash.new
  end

  def read_line(line)
    url, ip = line.split(' ')
    parsed_lines[url] ? parsed_lines[url] << ip : parsed_lines[url] = [ip]
  end

  def valid_line?(line)
    # TODO: bit simple - should convert to regex check
    line.split(' ').length == 2
  end
end
