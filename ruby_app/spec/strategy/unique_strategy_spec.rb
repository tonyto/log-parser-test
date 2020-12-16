# frozen_string_literal: true
require './lib/strategy/unique_strategy'
require './lib/strategy/report'

RSpec.describe UniqueStrategy do
  subject { described_class.new }

  describe '#parse' do
    let(:parsed_lines) do
      {
        '/help_page/1' => ['646.865.545.408', '646.865.545.408'],
        '/career' => ['646.865.555.444', '646.865.555.443'],
        '/about' => ['646.646.775.909']
      }
    end

    it 'output unique visit count' do
      expect(subject.parse(parsed_lines)).to have_attributes(
        name: subject.class,
        output: "/help_page/1 1 unique view\n/career 2 unique views\n/about 1 unique view\n"
      )
    end
  end
end
