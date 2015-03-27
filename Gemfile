source 'https://rubygems.org'

gem 'sinatra',  '~> 1.4.5'
gem 'httparty', '~> 0.13.1'
gem 'ultracart_xml_parser', github: 'TrialGuides/ultracart_xml_parser'

group :development do
  gem 'byebug'
end

group :production, :staging do
  gem 'newrelic_rpm'
  gem 'foreman'
  gem 'unicorn'
end

group :test do
  gem 'rspec',       '~> 2.14.1'
  gem 'rspec-mocks', '~> 2.14.6'
  gem 'rack-test',   '~> 0.6.2'
  gem 'webmock',     '~> 1.17.4'
end
