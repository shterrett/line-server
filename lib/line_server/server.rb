require 'sinatra'

get '/lines/:line_number' do
  request = LineRequest.new(params['line_number'])
  line = request.line
  if !line.empty?
    [200, line]
  elsif request.error == :eof
    [413, '']
  elsif request.error == :bad_input
    [422, '']
  end
end
