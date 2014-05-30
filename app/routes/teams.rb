module Sweepstakes
  module Routes
    class Teams < Base

      # error Models::NotFound do
      #   error 404
      # end

      # get '/teams', :auth => true do
      get '/teams' do
        content_type :json
        # Team.for_user(current_user).naked.all.to_json
        Team.naked.all.to_json
      end

    end
  end
end