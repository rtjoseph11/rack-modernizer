require 'rack-modernizer/version'
require 'json'

module Rack
  class Modernizer
    def initialize(app, modernizer)
      @app = app
      @modernizer = modernizer
    end

    def call(env)
      env = env.dup
      begin
        body = JSON.parse(env['rack.input'].read)
        env['rack.input'] = StringIO.new(@modernizer.translate({:env => env}, body).to_json)
      rescue JSON::ParserError
        return [400, {'Content-Type' => 'application/json'}, [{status: 400, message: 'Invalid JSON in body'}.to_json]]
      end

      @app.call(env)
    end
  end
end
