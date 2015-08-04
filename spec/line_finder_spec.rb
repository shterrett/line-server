require 'spec_helper'

describe LineFinder do
  let(:tmp_dir) { DATA_PATH.join('tmp') }
  let(:line_max) { 8 }
  before(:all) do
    create_searchable_files(tmp_dir: DATA_PATH.join('tmp'),
                            line_max: 8,
                            complete_files: 3,
                            partial_file_lines: 4
                           )
  end

  after(:all) do
    clean_tmp_folder(DATA_PATH.join('tmp'))
  end

  it 'reads from the file named N.txt where line_max * N == line ' do
    finder = LineFinder.new(tmp_dir, line_max)

    expect(File).to receive(:open).with(tmp_dir.join('16.txt').to_s).and_call_original

    finder.find(16)
  end

  it 'reads from the file named N.txt where line_max * N <= line < line_max * (N + 1) ' do
    finder = LineFinder.new(tmp_dir, line_max)

    expect(File).to receive(:open).with(tmp_dir.join('0.txt').to_s).and_call_original

    finder.find(7)
  end

  it 'reads the proper line from the file' do
    finder = LineFinder.new(tmp_dir, line_max)

    (0..35).each do |line_number|
      line = finder.find(line_number)
      expect(line).to include("total #{line_number}")
    end
  end

  it 'closes the file when finished' do
    file = File.open("#{tmp_dir}/0.txt")
    allow(File).to receive(:open).and_return(file)

    finder = LineFinder.new(tmp_dir, line_max)

    expect(file).to receive(:close)

    finder.find(0)
  end
end
