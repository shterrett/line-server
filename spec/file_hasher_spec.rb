require 'spec_helper'

describe FileHasher do
  let(:tmp_dir) { DATA_PATH.join('tmp') }

  after do
    Dir.new(tmp_dir).entries.each do |entry|
      if File.file?(tmp_dir.join(entry))
        File.delete(tmp_dir.join(entry))
      end
    end
  end

  it 'splits the file based on the passed-in line count' do
    path = DATA_PATH.join('full_file_24.txt')

    FileHasher.new(file: path,
                   target: tmp_dir,
                   line_max: 6
                  )
              .hash_file

    files = Dir.new(tmp_dir).entries

    ['0.txt', '6.txt', '12.txt', '18.txt'].each do |name|
      expect(files).to include name
    end
  end

  it 'writes files with a maximum of the passed in line count' do
    path = DATA_PATH.join('full_file_24.txt')

    FileHasher.new(file: path,
                   target: tmp_dir,
                   line_max: 5
                  )
              .hash_file

    ['0.txt', '5.txt', '10.txt', '15.txt'].each do |name|
      expect(File.readlines(tmp_dir.join(name)).length).to eq 5
    end

    expect(File.readlines(tmp_dir.join('20.txt')).length).to eq 4
  end
end
