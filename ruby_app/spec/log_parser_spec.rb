# frozen_string_literal: true

require './lib/log_parser'

RSpec.describe LogParser do
  subject { LogParser.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#reports' do
    let(:report) { double(:report) }
    let(:unique_strategy) { double }
    let(:all_strategy) { double }

    it 'returns reports from strategies' do
      allow(File).to receive(:foreach)

      allow(UniqueStrategy).to receive(:new).and_return(unique_strategy)
      allow(unique_strategy).to receive(:parse).and_return(report)
      allow(AllStrategy).to receive(:new).and_return(all_strategy)
      allow(all_strategy).to receive(:parse).and_return(report)

      subject.parse

      expect(subject.reports).to eq([report, report])
    end
  end

  describe '#parse' do
    context 'invalid rows' do
      it 'empty row populates #errors' do
        allow(File).to receive(:foreach)
          .and_yield('')

        subject.parse

        expect(subject.errors).to eq(['invalid line'])
      end

      it 'two IPs in a row populates #errors' do
        allow(File).to receive(:foreach)
          .and_yield('/about 0.0.0.0 646.464.646.464')

        subject.parse

        expect(subject.errors).to eq(['invalid line'])
      end
    end

    context 'valid rows' do
      it 'populates #result' do
        allow(File).to receive(:foreach)
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/career 646.865.555.444')
          .and_yield('/career 646.865.555.443')
          .and_yield('/about 646.646.775.909')

        subject.parse

        expect(subject.parsed_lines).to eq(
          {
            '/help_page/1' => ['646.865.545.408'],
            '/career' => ['646.865.555.444', '646.865.555.443'],
            '/about' => ['646.646.775.909']
          }
        )
      end
    end

    describe 'rescue File error' do
      it 'adds to error' do
        allow(File).to receive(:foreach).and_raise('error')
        subject.parse
        expect(subject.errors.length).to eq(1)
      end
    end
  end
end