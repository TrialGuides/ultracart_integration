require 'rubygems'
require 'bundler'

require './lib/ultracart_connector'

Bundler.require(:default)
require './ultracart_connector'
run UltraCartConnector
