require 'pry'
require 'rspec'
require 'simplecov'
require 'rack/test'

SimpleCov.start do
  add_filter 'spec/'
end

# encoding: utf-8
$LOAD_PATH.unshift(File.dirname(__FILE__))
$LOAD_PATH.unshift(File.join(File.dirname(__FILE__), '..', 'lib'))

Dir['./spec/shared/**/*.rb'].sort.each { |f| require f }
Dir['./spec/support/*.rb'].sort.each { |f| require f }
require_relative '../lib/line_server'

DATA_PATH = Pathname.new('spec/data')

RSpec.configure do |config|
  config.order = 'random'
  config.include TempFileManagement
end
