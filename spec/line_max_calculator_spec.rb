require 'spec_helper'

describe LineMaxCalculator do
  after do
    clean_tmp_folder(DATA_PATH.join('tmp'))
  end

  describe 'Uses the formula log[base 2](number of lines in the file)
            to determine the number of files into which to divide the original
            file. The maximum number of lines used is the ceiling of the ratio
            of the number of lines in the file to the number of files.
            The maximum number of lines is limited to 1024' do

    it 'returns the calculated line_max for a file where the division yields
        a line max less than 1024' do
      path = DATA_PATH.join('tmp', 'original.txt')
      File.open(path, 'w') do |f|
        2048.times { f.puts "There are four lights!" }
      end

      calculator = LineMaxCalculator.new(path)

      expect(calculator.line_max).to eq 187
    end

    it 'returns the 1024 for a file where the division yields
        a line max greater than 1024' do
      path = DATA_PATH.join('tmp', 'original.txt')
      file_double = double('file')
      file_double.stub_chain('each_line.reduce').and_return(2 ** 14)
      allow(File).to receive(:open).and_yield(file_double)

      calculator = LineMaxCalculator.new(path)

      expect(calculator.line_max).to eq 1024
    end
  end
end
