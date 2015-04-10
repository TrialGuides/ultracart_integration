require 'rubygems'
require 'bundler'

require './lib/ultracart_integration'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)
require './ultracart_integration'
run UltraCartIntegration
