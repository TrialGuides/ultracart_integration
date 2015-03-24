require 'spec_helper'

describe UltraCartConnector do
  before :each do
    @headers = { 'X-Hub-Store' => ENV['HUB_STORE'], 'X-Hub-Access-Token' => ENV['HUB_ACCESS_TOKEN'] }
  end

  it 'responds to AR XML correctly' do
    hub_json = json_fixture('ar')
    stub = stub_request(:post, HUB_ENDPOINT).with(body: hub_json, headers: @headers)

    request = xml_fixture('ar')
    post '/', request

    stub.should have_been_requested
    expect(last_response).to be_ok
  end

  it 'responds to SD XML correctly' do
    hub_json = json_fixture('sd')
    stub = stub_request(:post, HUB_ENDPOINT).with(body: hub_json, headers: @headers)

    request = xml_fixture('sd')
    post '/', request

    stub.should have_been_requested
    expect(last_response).to be_ok
  end

  it 'responds to REJ XML correctly' do
    hub_json = json_fixture('rej')
    stub = stub_request(:post, HUB_ENDPOINT).with(body: hub_json, headers: @headers)

    request = xml_fixture('rej')
    post '/', request

    stub.should have_been_requested
    expect(last_response).to be_ok
  end

  it 'responds to CO XML correctly' do
    hub_json = json_fixture('co')
    stub = stub_request(:post, HUB_ENDPOINT).with(body: hub_json, headers: @headers)

    request = xml_fixture('co')
    post '/', request

    stub.should have_been_requested
    expect(last_response).to be_ok
  end

  it 'responds to CO XML without subscription correctly' do
    hub_json = json_fixture('co_no_sub')
    stub = stub_request(:post, HUB_ENDPOINT).with(body: hub_json, headers: @headers)

    request = xml_fixture('co_no_sub')
    post '/', request

    stub.should have_been_requested
    expect(last_response).to be_ok
  end

  it 'should fail on timeout' do
    stub_request(:post, HUB_ENDPOINT).to_timeout

    request = xml_fixture('co')
    post '/', request

    expect(last_response).to_not be_ok
  end
end
