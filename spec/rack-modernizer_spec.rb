require 'modernizer'
require File.expand_path('../../lib/rack-modernizer.rb', __FILE__)
require 'minitest/autorun'
require 'rack'
require 'rack/test'
require 'mocha/setup'
require 'json'
require 'rack'
require 'stringio'

class MiniTest::Unit::TestCase
  include Mocha::API
  include Rack::Test::Methods

  def app
    modernizer = Modernize::Modernizer.new do
      version {@hash['version']}
      modernize '0.0.1' do
        add('foo') {'bar'}
      end
      modernize '0.0.3' do
        compute('hello') {|string| string + '!'}
      end
    end
    Rack::Builder.new do
      use Rack::Modernizer, modernizer
      run Proc.new {|env| 
        body = env['rack.input'].read
        [200, {'Content-Type' => 'application/json'}, body]
      }
    end.to_app
  end
end

describe 'Rack::Modernizer' do
  
  it 'makes changes to gets' do
    get '/?headers=1', {}, 'rack.input' => StringIO.new(JSON.dump({'version' => '0.0.1'}))
    body = JSON.parse(last_response.body)
    assert_equal body, {'version' => '0.0.1', 'foo' => 'bar'}
  end

  it 'modifies the body' do
    body = {'hello' => 'world', 'mark' => 'kinsella', 'version' => '0.0.1'}
    post '/', {}, 'rack.input' => StringIO.new(JSON.dump(body))
    resp_body = JSON.parse(last_response.body)
    assert_equal resp_body, {'hello' => 'world!', 'mark' => 'kinsella', 'version' => '0.0.1', 'foo' => 'bar'}
  end

  it 'responds with a 400 error when the body has invalid json' do
    post '/', {}, 'rack.input' => StringIO.new('I am invalid!')
    assert_equal last_response.status, 400
    body = JSON.parse(last_response.body)
    assert_equal body, {'status' => 400, 'message' => 'Invalid JSON in body'}
  end
end