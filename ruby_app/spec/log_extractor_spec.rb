# frozen_string_literal: true

require './lib/log_extractor'

RSpec.describe LogExtractor do
  subject { described_class.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#parse' do
    context 'invalid rows' do
      it 'empty row populates #errors' do
        allow(File).to receive(:foreach)
          .and_yield('')

        expect(subject.parse).to eq({
          errors: ['invalid line'],
          parsed_lines: {}
        })
      end

      it 'two IPs in a row populates #errors' do
        allow(File).to receive(:foreach)
          .and_yield('/about 0.0.0.0 646.464.646.464')

        expect(subject.parse).to eq({
          errors: ['invalid line'],
          parsed_lines: {}
        })
      end
    end

    context 'valid rows' do
      it 'populates #result' do
        allow(File).to receive(:foreach)
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/career 646.865.555.444')
          .and_yield('/career 646.865.555.443')
          .and_yield('/about 646.646.775.909')

        expect(subject.parse).to eq(
          {
            errors: [],
            parsed_lines: {
              '/help_page/1' => ['646.865.545.408'],
              '/career' => ['646.865.555.444', '646.865.555.443'],
              '/about' => ['646.646.775.909']
            }
          }
        )
      end
    end

    describe 'rescue File error' do
      it 'adds to error' do
        allow(File).to receive(:foreach).and_raise('error')
        expect(subject.parse).to eq({
          errors: [StandardError.new('error')],
          parsed_lines: {}
        })
      end
    end
  end
end