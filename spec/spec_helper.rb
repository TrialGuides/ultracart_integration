require 'rubygems'
require 'bundler'

Bundler.require(:default, :test)

require 'webmock/rspec'

require File.join(File.dirname(__FILE__), '..', 'lib', 'ultracart_connector')
require File.join(File.dirname(__FILE__), '..', 'ultracart_connector')

AWS.stub!

Sinatra::Base.environment = 'test'

def app
  UltraCartConnector
end

def xml_fixture(path)
  IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'xml', "#{path}.xml")).chomp
end

def json_fixture(path)
  IO.read(File.join(File.dirname(__FILE__), 'fixtures', 'json', "#{path}.json")).chomp
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
end

ENV['HUB_STORE'] = '<<<HUB_STORE>>>'
ENV['HUB_ACCESS_TOKEN'] = '<<<HUB_ACCESS_TOKEN>>>'
ENV['EMAIL_LIST'] = '<<<EMAIL_LIST>>>'
ENV['AWS_ACCESS_KEY_ID'] = '<<<AWS_ACCESS_KEY>>>'
ENV['AWS_SECRET_ACCESS_KEY'] = '<<<AWS_SECRET_ACCESS_KEY>>>'
ENV['AWS_S3_BUCKET'] = '<<<AWS_S3_BUCKET>>>'
