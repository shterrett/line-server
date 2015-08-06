require 'spec_helper'

describe DirectoryCleaner do
  it 'empties a directory' do
    5.times do |i|
      File.open("#{DATA_PATH.join('tmp')}/#{i}.txt", 'w') do |f|
        f.puts "hi!"
      end
    end

    DirectoryCleaner.new(DATA_PATH.join('tmp')).clean

    expect(Dir.entries(DATA_PATH.join('tmp'))).to eq ['.', '..']
  end
end
