$:<<::File.dirname(__FILE__)

require 'sinatra/base'
require 'ap'
require 'json'
# require 'sinatra/respond_to'
require 'rest_client'


class App < Sinatra::Base

  # enable :sessions

  configure do
  #   set :views, settings.root + '/app/views'
    enable :logging
    set :root, File.dirname(__FILE__)
    set :public_folder, ENV['RACK_ENV'] == 'production' ? 'public/dist' : 'public/app'
    # set :styles_folder, ENV['RACK_ENV'] == 'production' ? 'public/dist/styles' : 'public/.tmp/styles';
  end

  before do
    # content_type :json
  #   if Sinatra::Base.development?
  #     response.headers['Access-Control-Allow-Origin'] = '*'
  #     response.headers['Access-Control-Allow-Methods'] = 'GET, POST, OPTIONS'
  #     response.headers['Access-Control-Allow-Headers'] = 'X-CSRF-Token' # This is a Rails header, you may not need it
  #   end
  end

  get '/hello' do
    content_type :json
    { message: 'Hello World!' }.to_json
  end

  get '*' do
    send_file File.join(settings.public_folder, 'index.html')
  end

  not_found do
    content_type :json
    halt 404, { error: 'URL not found' }.to_json
  end

  # start the server if ruby file executed directly
  run! if __FILE__ == $0
end
