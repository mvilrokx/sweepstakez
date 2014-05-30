module Sweepstakes
  module Routes
    class Picks < Base

      # error Models::NotFound do
      #   error 404
      # end

      # get '/picks', :auth => true do
      get '/teams/:id/picks' do
        content_type :json
        Team.first!(id: params[:id]).picks.naked.all.to_json
      end

    end
  end
end