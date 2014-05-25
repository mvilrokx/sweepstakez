module Sweepstakes
  module Routes
    class Countries < Base

      # error Models::NotFound do
      #   error 404
      # end

      get '/countries/:country_code' do
        content_type :json
        Country.where(:country_code => params[:country_code]).naked.all.to_json
      end

      get '/countries' do
        content_type :json
        Country.naked.all.to_json
      end

    end
  end
end