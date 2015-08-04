require 'spec_helper'

describe 'webserver' do
  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

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

  it 'returns a 200 code if the line is found' do
    get '/lines/0'

    expect(last_response.status).to eq 200
  end

  it 'returns the text of the line if it is found' do
    get '/lines/10'

    expect(last_response.body).to eq "#{file_line(8, 10 - 8)}\n"
  end

  it 'returns a 413 code if the line is not found' do
    get '/lines/10000'

    expect(last_response.status).to eq 413
  end

  it 'returns an empty response if the line is not found' do
    get '/lines/10000'

    expect(last_response.body).to eq ''
  end

  it 'returns a 422 if the input line number is not an integer' do
    get '/lines/hello'

    expect(last_response.body).to eq ''
    expect(last_response.status).to eq 422
  end
end
