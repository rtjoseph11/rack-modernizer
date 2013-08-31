# Rack::Modernizer

rack middleware making use of the modernizer library

## Installation

Add this line to your application's Gemfile:

    gem 'rack-modernizer'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rack-modernizer

## Usage
in config/modernizations

```ruby
  require 'modernizer'
  module Config
    Modernizations = Modernize::Modernizer.new do
      version {# a block to determine the version}
      modernize 'some version' do
        # things to do to the version
      end
    end
  end
```

in the config.ru
```ruby
  require 'config/modernizations'
  require 'rack-modernizer'

  use Rack::Modernizer, Config::Modernizations
```

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
