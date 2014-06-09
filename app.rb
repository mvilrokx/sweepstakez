require 'rubygems'
require 'bundler'

Bundler.require

# ensure that the current directory is in the app's load path (aliased to $:).
$: << File.expand_path('../', __FILE__)
# ... ditto for the lib path
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'active_support/json'
require 'rack/contrib'
# require 'rack/csrf'

require 'app/routes'
require 'app/models'
require 'app/extensions'

module Sweepstakes
  class App < Sinatra::Application

    # Make sure you create a PG DB first on your local machine using
    # $ createdb sweepstakes_development
    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/sweepstakes_#{environment}"
      }
    end

    configure do
      enable :logging
      enable :methodoverride

      set :root, File.dirname(__FILE__)
      set :public_folder, ENV['RACK_ENV'] == 'production' ? 'public/dist' : 'public/app'

      set :protection, except: :session_hijacking

      set :sessions,
          :httponly     => true,
          # This breaks omniauth in production so removed this for now
          # :secure       => production?,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET']
    end

    # test with curl -i http://localhost:4567/hello -H "Accept-Encoding: gzip,deflate
    use Rack::Deflater
    # use Rack::Csrf
    # This Rack extension transparently converts JSON to form post data and puts it into the params Hash
    use Rack::PostBodyContentTypeParser

    use Sweepstakes::Routes::Users
    use Sweepstakes::Routes::Teams
    use Sweepstakes::Routes::Picks
    use Sweepstakes::Routes::Countries
    use Sweepstakes::Routes::Tournaments

    # Angular.js!!!
    get '/' do
      send_file File.join(settings.public_folder, 'index.html')
    end

    not_found do
      content_type :json
      halt 404, { error: 'URL not found' }.to_json
    end

    # start the server if ruby file executed directly
    run! if __FILE__ == $0
  end
end

# To easily access models in the console
include Sweepstakes::Models