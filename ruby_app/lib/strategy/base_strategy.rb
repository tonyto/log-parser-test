# frozen_string_literal: true

class BaseStrategy
  def parse
    raise NotImplementedError, "#{self.class} has not implemented #{__method__}"
  end
end