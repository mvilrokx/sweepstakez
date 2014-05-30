require 'rubygems'
require 'bundler'

Bundler.require

# ensure that the current directory is in the app's load path (aliased to $:).
$: << File.expand_path('../', __FILE__)
$: << File.expand_path('../lib', __FILE__)

require 'dotenv'
Dotenv.load

require 'active_support/json'
# require 'rack/csrf'

require 'app/routes'
require 'app/models'
require 'app/extensions'

module Sweepstakes
  class App < Sinatra::Application

    configure do
      set :database, lambda {
        ENV['DATABASE_URL'] ||
          "postgres://localhost:5432/sweepstakes_#{environment}"
      }
    end

    configure do
      enable :logging
      set :root, File.dirname(__FILE__)
      set :public_folder, ENV['RACK_ENV'] == 'production' ? 'public/dist' : 'public/app'

      set :protection, except: :session_hijacking

      set :sessions,
          :httponly     => true,
          # This breaks omniauth so removed this for now
          # :secure       => production?,
          :expire_after => 31557600, # 1 year
          :secret       => ENV['SESSION_SECRET']
    end

    # test with curl -i http://localhost:4567/hello -H "Accept-Encoding: gzip,deflate
    use Rack::Deflater
    # use Rack::Csrf

    use Sweepstakes::Routes::Users
    use Sweepstakes::Routes::Teams
    use Sweepstakes::Routes::Picks
    use Sweepstakes::Routes::Countries
    use Sweepstakes::Routes::Tournaments


    before do
      # content_type :json
      # if Sinatra::Base.development?
      #   response.headers['Access-Control-Allow-Origin'] = '*'
      #   response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
      #   response.headers['Access-Control-Allow-Headers'] = 'X-CSRF-Token' # This is a Rails header, you may not need it
      # end
    end

    # Angular.js
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