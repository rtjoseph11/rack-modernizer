require "rack/modernizer/version"
require 'modernizer'
require 'json'
module Rack
  class Modernizer
    def self.configure(&block)
      @@modernizer = Modernize::Modernizer.new(&block)
      self
    end

    def initialize(app)
      @app = app
    end

    def call(env)
      return @app.call(env) unless env['REQUEST_METHOD'] == 'POST'
      env = env.dup

      begin
        body = JSON.parse(env['rack.input'].read)
        env['rack.input'] = StringIO.new(@@modernize.translate(env, body).to_json)
      rescue JSON::ParserError
        return [400, {'Content-Type' => 'application/json'}, [{status: 400, message: 'Invalid JSON in headers query string param'}.to_json]]
      end

      @app.call(env)
    end
  end
end
