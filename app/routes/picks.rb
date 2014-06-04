module Sweepstakes
  module Routes
    class Picks < Base

      get '/teams/:team_id/picks', :auth => true do
        team = Team.first!(id: params[:team_id])
        picks = team.picks_dataset
        json picks
      end

      get '/teams/:team_id/picks/:id', :auth => true do
        pick = Pick.first!(id: params[:id])
        json pick
      end

      post '/teams/:team_id/picks', :auth => true do
        pick      = Pick.new
        pick.set_fields(params, [:team_id, :tournament_participant_id, :position])
        pick.save
        json pick
      end

      put '/teams/:team_id/picks/:id', :auth => true do
        pick = Pick.first!(id: params[:id])
        if params[:tournament_participant_id] then
          pick.set_fields(params, [:team_id, :tournament_participant_id, :position])
        else
          pick.set_fields(params, [:team_id, :position])
        end
        pick.save
        json pick
      end

      delete '/teams/:team_id/picks/:id', :auth => true do
        pick = Pick.first!(id: params[:id])
        pick.delete
        json pick
      end

    end
  end
end