source 'https://rubygems.org'

gem 'sinatra'
gem 'httparty'
gem 'ultracart_xml_parser', github: 'TrialGuides/ultracart_xml_parser'

group :development do
  gem 'pry'
end

group :production, :staging do
  gem 'newrelic_rpm'
  gem 'foreman'
  gem 'unicorn'
end

group :test do
  gem 'rspec'
  gem 'webmock'
  gem 'guard-rspec'
  gem 'terminal-notifier-guard'
  gem 'rb-fsevent', '~> 0.9.1'
  gem 'rack-test'
end
