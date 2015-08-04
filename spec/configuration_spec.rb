require 'spec_helper'

describe Configuration do
  it 'stores configuration information' do
    Configuration.set do |config|
      config.line_max = 8
      config.hash_file_dir = 'some/dir'
    end

    expect(Configuration.get.line_max).to eq 8
    expect(Configuration.get.hash_file_dir).to eq 'some/dir'
  end
end
