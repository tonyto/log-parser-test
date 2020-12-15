class LogParser
  def initialize(file_path)
    @file_path = file_path
  end

  def parse
    result = Hash.new
    output = ''

    File.foreach(@file_path) do |line|
      url, ip = line.split(' ')
      result[url] ? result[url] << ip : result[url] = [ip]
    end

    result.each{|k, v| output += format_output(k, v)}

    output
  end

  private

  def format_output(key, value)
    value.length > 1 ? "#{key} #{value.length} visits\n" : "#{key} #{value.length} visit"
  end
end

RSpec.describe LogParser do
  subject { LogParser.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#parse' do
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

        expect(subject.parse).to eq(
          "/help_page/1 3 visits\n" \
          "/career 2 visits\n" \
          "/about 2 visits\n"
        )
      end
    end

    it 'reads single line' do
      allow(File).to receive(:foreach).and_yield('/help_page/1 646.865.545.408')

      expect(subject.parse).to eq('/help_page/1 1 visit')
    end

    it 'reads multiple lines' do
      allow(File).to receive(:foreach)
        .and_yield('/help_page/1 646.865.545.408')
        .and_yield('/career 646.865.555.444')
        .and_yield('/about 646.646.775.909')

      expect(subject.parse).to eq(
        '/help_page/1 1 visit' \
        '/career 1 visit' \
        '/about 1 visit'
      )
    end
  end
end