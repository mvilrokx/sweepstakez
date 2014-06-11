module Sweepstakes
  module Routes
    class Picks < Base

      # Query All
      get '/teams/:team_id/picks', :auth => true do
        team = Team.for_tenant(current_tenant).first!(id: params[:team_id])
        picks = team.picks_dataset
        json picks
      end

      # Query one
      get '/teams/:team_id/picks/:id', :auth => true do
        pick = Pick.first!(id: params[:id])
        json pick
      end

      # Create
      post '/teams/:team_id/picks', :auth => true do
        pick      = Pick.new
        pick.tenant = current_tenant
        pick.set_fields(params, [:team_id, :tournament_participant_id, :position])

        pick.save
        json pick
      end

      # Update
      put '/teams/:team_id/picks/:id', :auth => true do
        if current_user.admin?
          pick = Pick.first!(id: params[:id])
        else
          pick = Pick.select_all(:picks).for_user(current_user).first!(picks__id: params[:id])
        end

        if params[:tournament_participant_id] then
          pick.set_fields(params, [:team_id, :tournament_participant_id, :position])
        else
          pick.set_fields(params, [:team_id, :position])
        end

        pick.save
        json pick
      end

      # Delete
      delete '/teams/:team_id/picks/:id', :auth => true do
        if current_user.admin?
          pick = Pick.first!(id: params[:id])
        else
          pick = Pick.select_all(:picks).for_user(current_user).first!(picks__id: params[:id])
        end

        pick.destroy
        json pick
      end

    end
  end
end