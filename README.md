# Guard::Zeus::Server

Starts/stops/restarts your rails server via zeus.

## Installation

Add this line to your application's Gemfile:

    gem 'guard-zeus_server'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install guard-zeus_server

## Usage

Run:

    $ guard init zeus_server

Modify the `Guardfile` to your heart's content.

Options:

  * `:port` is the port number to pass to `zeus server`. Defaults to `3000`.
  * `:command` is the zeus command to run. Defaults to `server`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request
