# frozen_string_literal: true

class LogParser
  attr_accessor :strategies, :result

  def initialize(file_path)
    @file_path = file_path
    @strategies = [UniqueStrategy, AllStrategy]
    @result = []
  end

  def reports
    strategies.each do |strategy|
      result.push(strategy.new.parse(parsed_lines))
    end

    result
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
  end

  def errors
    @errors ||= []
  end

  def parsed_lines
    @parsed_lines ||= Hash.new
  end

  private

  def read_line(line)
    url, ip = line.split(' ')
    parsed_lines[url] ? parsed_lines[url] << ip : parsed_lines[url] = [ip]
  end

  def valid_line?(line)
    line.split(' ').length == 2
  end
end
