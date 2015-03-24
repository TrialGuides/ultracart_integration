require 'json'

HUB_ENDPOINT = ENV['HUB_ENDPOINT'] || 'https://wombat.co/push'
HUB_TIMEOUT = ENV['HUB_TIMEOUT'] || 240

class UltraCartConnector < Sinatra::Base
  attr_reader :payload

  before do
    @order = UltraCartOrder.new(request.body.read)
  end

  post '/' do
    response = HTTParty.post(
      HUB_ENDPOINT,
      body: SpreeObject.data(@order).to_json,
      timeout: HUB_TIMEOUT,
      headers: {
        'X-Hub-Store'        => ENV['HUB_STORE'],
        'X-Hub-Access-Token' => ENV['HUB_ACCESS_TOKEN']
      }
    )
    [response.code < 300 ? 200 : response.code, {}, response.body]
  end
end
