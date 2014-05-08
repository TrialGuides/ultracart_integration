require 'json'

HUB_ENDPOINT = 'https://push.hubapp.io'
HUB_TIMEOUT = 240

class UltraCartConnector < Sinatra::Base
  attr_reader :payload

  before do
    @order = UltraCartOrder.new(request.body.read)
  end

  post '/' do
    S3Archiver.data(@order)
    response = HTTParty.post(
      HUB_ENDPOINT,
      body: SpreeObject.data(@order).to_json,
      timeout: HUB_TIMEOUT,
      headers: {
        'X-Hub-Store'        => ENV['HUB_STORE'],
        'X-Hub-Access-Token' => ENV['HUB_ACCESS_TOKEN']
      },
      # TODO: Enable verification once SSL issue is resolved
      verify: false
    )
    [response.code, {}, response.body]
  end
end
