source 'https://rubygems.org'

gem 'sinatra',  '~> 1.4.5'
gem 'nokogiri', '~> 1.6.1'
gem 'httparty', '~> 0.13.1'
gem 'carmen',   '~> 1.0.1'

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
