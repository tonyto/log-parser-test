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

    result.each{|k, v| output += "#{k} #{v.length} visit"}

    output
  end
end

RSpec.describe LogParser do
  subject { LogParser.new(file_path) }
  let(:file_path) { '/path_to_file.log' }

  describe '#parse' do
    it 'reads first line' do
      allow(File).to receive(:foreach).and_yield('/help_page/1 646.865.545.408')

      expect(subject.parse).to eq('/help_page/1 1 visit')
    end
  end
end