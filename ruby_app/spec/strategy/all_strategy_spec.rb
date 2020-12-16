# frozen_string_literal: true
require './lib/strategy/all_strategy'
require './lib/strategy/report'

RSpec.describe AllStrategy do
  subject { described_class.new }

  describe '#parse' do
    let(:parsed_lines) do
      {
        '/help_page/1' => ['646.865.545.408', '646.865.545.408'],
        '/career' => ['646.865.555.444', '646.865.555.443'],
        '/about' => ['646.646.775.909']
      }
    end

    it 'output all visit count' do
      expect(subject.parse(parsed_lines)).to have_attributes(
        name: subject.class,
        output: "/help_page/1 2 visits\n/career 2 visits\n/about 1 visit\n"
      )
    end
  end
end
