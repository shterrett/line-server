require 'spec_helper'

describe LineRequest do
  before(:all) do
    create_searchable_files(tmp_dir: DATA_PATH.join('tmp'),
                            line_max: 8,
                            complete_files: 3,
                            partial_file_lines: 4
                           )

    Configuration.set do |config|
      config.line_max = 8
      config.hash_file_dir = DATA_PATH.join('tmp')
    end
  end

  after(:all) do
    clean_tmp_folder(DATA_PATH.join('tmp'))

    Configuration.instance_variable_set(:@config, nil)
  end

  it 'returns the line if it is found' do
    request = LineRequest.new(18)

    expect(request.line.strip).to eq file_line(16, 18 - 16)
  end

  it 'returns an empty string if the line is beyond the end of the file' do
    request = LineRequest.new(10000000)

    expect(request.line.strip).to eq ''
  end

  it 'returns an error of :eof if the line is beyond the end of the file' do
    request = LineRequest.new(10000000)

    expect(request.line.strip).to eq ''
    expect(request.error).to eq :eof
  end

  it 'returns an error of :bad_input if the line_number is not an integer' do
    request = LineRequest.new('hi')

    expect(request.line.strip).to eq ''
    expect(request.error).to eq :bad_input
  end

  it 'coerces a string into an integer where possible' do
    request = LineRequest.new('25')

    expect(request.line.strip).to eq file_line(24, 25 - 24)
    expect(request.error).to be_nil
  end
end
