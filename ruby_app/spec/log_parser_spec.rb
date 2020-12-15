# frozen_string_literal: true

require './lib/log_parser'

RSpec.describe LogParser do
  subject { LogParser.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#parse' do
    context 'invalid rows' do
      it 'empty row populates #errors' do
        allow(File).to receive(:foreach)
          .and_yield('')

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

        expect(subject.result).to eq(
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

  describe '#parse_unique' do
    context 'multiple unique visits' do
      it 'outputs unique visit' do
        allow(File).to receive(:foreach)
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/help_page/1 646.865.545.407')
          .and_yield('/help_page/1 646.865.545.406')
          .and_yield('/career 646.865.555.444')
          .and_yield('/career 646.865.555.443')
          .and_yield('/about 646.646.775.909')
          .and_yield('/about 646.646.775.908')

        subject.parse

        expect(subject.parse_unique).to eq(
          "/help_page/1 3 unique views\n" \
          "/career 2 unique views\n" \
          "/about 2 unique views\n"
        )
      end
    end

    context 'single unique visit' do
      it 'outputs unique visit' do
        allow(File).to receive(:foreach)
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/career 646.865.555.444')
          .and_yield('/about 646.646.775.909')

        subject.parse

        expect(subject.parse_unique).to eq(
          "/help_page/1 1 unique view\n" \
          "/career 1 unique view\n" \
          "/about 1 unique view\n"
        )
      end
    end
  end

  describe '#parse_all' do
    context 'multiple visits for a url' do
      it 'pluralises visits' do
        allow(File).to receive(:foreach)
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/help_page/1 646.865.545.408')
          .and_yield('/career 646.865.555.444')
          .and_yield('/career 646.865.555.444')
          .and_yield('/about 646.646.775.909')
          .and_yield('/about 646.646.775.909')

        subject.parse

        expect(subject.parse_all).to eq(
          "/help_page/1 3 visits\n" \
          "/career 2 visits\n" \
          "/about 2 visits\n"
        )
      end
    end

    it 'reads single line' do
      allow(File).to receive(:foreach).and_yield('/help_page/1 646.865.545.408')

      subject.parse

      expect(subject.parse_all).to eq("/help_page/1 1 visit\n")
    end

    it 'reads multiple lines' do
      allow(File).to receive(:foreach)
        .and_yield('/help_page/1 646.865.545.408')
        .and_yield('/career 646.865.555.444')
        .and_yield('/about 646.646.775.909')

      subject.parse

      expect(subject.parse_all).to eq(
        "/help_page/1 1 visit\n" \
        "/career 1 visit\n" \
        "/about 1 visit\n"
      )
    end
  end
end