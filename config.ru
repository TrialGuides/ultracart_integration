require 'rubygems'
require 'bundler'

require './lib/ultracart_connector'

Bundler.require(:default, ENV['RACK_ENV'].to_sym)
require './ultracart_connector'
run UltraCartConnector
