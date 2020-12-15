class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    begin
      File.foreach(@file_path) do |line|
        if valid_line?(line)
          url, ip = line.split(' ')
          result[url] ? result[url] << ip : result[url] = [ip]
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

  def result
    @result ||= Hash.new
  end

  def parse_all
    output = ''

    result.each{|k, v| output += format_output(k, v)}

    output
  end

  def parse_unique
    output = ''

    result.each{|k, v| output += format_unique_output(k, v)}

    output
  end

  private

  def valid_line?(line)
    line.split(' ').length == 2
  end

  def format_unique_output(key, value)
    unique_value = value.uniq
    unique_value.length > 1 ? "#{key} #{unique_value.length} unique views\n" : "#{key} #{unique_value.length} unique view\n"
  end

  def format_output(key, value)
    value.length > 1 ? "#{key} #{value.length} visits\n" : "#{key} #{value.length} visit\n"
  end
end

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