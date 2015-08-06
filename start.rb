require_relative 'lib/line_server'

path_to_original_file = ARGV[0]

Configuration.set do |config|
  config.line_max = LineMaxCalculator.new(path_to_original_file).line_max
  config.hash_file_dir = './tmp'
end

DirectoryCleaner.new(Configuration.get.hash_file_dir).clean

FileHasher.new(file: path_to_original_file,
               target: Configuration.get.hash_file_dir,
               line_max: Configuration.get.line_max
              ).hash_file

Sinatra::Application.run!
