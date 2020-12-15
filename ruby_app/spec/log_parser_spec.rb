class LogParser
  def initialize; end;

  def parse

  end
end

RSpec.describe LogParser do
  describe 'new' do
    it { expect(described_class.new).to_not be(nil) }
  end
end