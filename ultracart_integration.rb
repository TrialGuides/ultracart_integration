require 'json'
require 'ultracart_xml_parser'

HUB_ENDPOINT = ENV['HUB_ENDPOINT'] || 'https://wombat.co/push'
HUB_TIMEOUT = ENV['HUB_TIMEOUT'] || 240

class UltraCartIntegration < Sinatra::Base
  attr_reader :payload

  before do
    @order = OrderDetails.parse(request.body.read)
  end

  post '/' do
    response = HTTParty.post(
      HUB_ENDPOINT,
      body: WombatObjects.serialize(@order),
      timeout: HUB_TIMEOUT,
      headers: {
        'X-Hub-Store'        => ENV['HUB_STORE'],
        'X-Hub-Access-Token' => ENV['HUB_ACCESS_TOKEN']
      }
    )
    [response.code < 300 ? 200 : response.code, {}, response.body]
  end
end
