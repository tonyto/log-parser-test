# frozen_string_literal: true

class Report
  attr_accessor :name, :output

  def initialize(name, output)
    @name = name
    @output = output
  end
end