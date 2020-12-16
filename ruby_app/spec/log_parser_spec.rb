# frozen_string_literal: true

require './lib/log_parser'
require './lib/log_extractor'

RSpec.describe LogParser do
  subject { described_class.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#reports' do
    let(:report) { double(:report) }
    let(:unique_strategy) { double }
    let(:all_strategy) { double }
    let(:log_extractor) { double }
    let(:extracted_logs) { { errors: [], parsed_lines: { '/help_page/1' => ['646.865.545.408'] } } }

    it 'returns reports from strategies' do
      allow(LogExtractor).to receive(:new).and_return(log_extractor)
      allow(log_extractor).to receive(:parse).and_return(extracted_logs)

      allow(UniqueStrategy).to receive(:new).and_return(unique_strategy)
      allow(unique_strategy).to receive(:parse).with(extracted_logs[:parsed_lines]).and_return(report)
      allow(AllStrategy).to receive(:new).and_return(all_strategy)
      allow(all_strategy).to receive(:parse).with(extracted_logs[:parsed_lines]).and_return(report)

      expect(subject.reports).to eq([report, report])
    end
  end
end