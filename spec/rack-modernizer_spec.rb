require 'json'
require 'rspec'
require 'stringio'
require 'uri'
require 'rack'
require 'rack/test'
$: << File.dirname(__FILE__) + '/../lib'
require 'rack-modernizer'

describe Rack::RequestModernizer do
  include Rack::Test::Methods
  Rack::RequestModernizer.configure do |env, body|
    version {@body['version']}
    modernize '0.0.1' do
      add('foo') {'bar'}
    end
    modernize '0.0.3' do
      compute('hello') {|string| string + '!'}
    end
  end
  let(:inner_app) do
    lambda { |env|
      new_env = env.dup
      body = new_env['rack.input'].read
      headers = env.select {|k,v| k.start_with? 'HTTP_'}
      [200, {'Content-Type' => 'application/json'}, body]
    }
  end
 
  let(:app) { Rack::RequestModernizer.new(inner_app) }
  
  it "makes no change to gets" do
    get "/?headers='1'", {}, 'rack.input' => StringIO.new(JSON.dump({"version" => '0.0.1'}))
    body = JSON.parse(last_response.body)
    body.should eq({"version" => '0.0.1'})
  end

  it 'modifies the body' do
    body = {"hello" => "world", "mark" => "kinsella", "version" => '0.0.1'}
    post '/', {}, 'rack.input' => StringIO.new(JSON.dump(body))
    resp_body = JSON.parse(last_response.body)
    resp_body.should eq({"hello" => "world!", "mark" => "kinsella", "version" => '0.0.1', 'foo' => 'bar'})
  end

  it 'responds with a 400 error when the body has invalid json' do
    post '/', {}, 'rack.input' => StringIO.new('I am invalid!')
    last_response.status.should eq(400)
    body = JSON.parse(last_response.body)
    body.should eq({'status' => 400, 'message' => 'Invalid JSON in body'})
  end
end