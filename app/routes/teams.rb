module Sweepstakes
  module Routes
    class Teams < Base

      # Query All
      get '/teams', :auth => true do
        json Team.for_user(current_user).for_tenant(current_tenant)
        # json Team.for_user(current_user)
      end

      # Query one
      get '/teams/:id', :auth => true do
        if current_user.admin?
          team = Team.first!(id: params[:id])
        else
          team = Team.for_user(current_user).for_tenant(current_tenant).first!(id: params[:id])
        end
        json team
      end

      # Create
      post '/teams', :auth => true do
        team      = Team.new
        team.user = current_user
        team.tenant = current_tenant

        team.tournament_id = Tournament.active.first[:id]

        team.set_fields(params, [:name])
        # team.set_fields(params, [:name, :tournament_id])

        team.save

        json team
      end

      # Update
      put '/teams/:id', :auth => true do
        if current_user.admin?
          team = Team.first!(id: params[:id])
        else
          team = Team.for_user(current_user).for_tenant(current_tenant).first!(id: params[:id])
        end
        team.update(name: params[:name])

        json team
      end

      # Delete
      delete '/teams/:id', :auth => true do
        if current_user.admin?
          team = Team.first!(id: params[:id])
        else
          team = Team.for_user(current_user).for_tenant(current_tenant).first!(id: params[:id])
        end
        # team.delete
        team.destroy
        json team
      end

      # get '/teams/:id/picks', :auth => true do
      #   team = Team.first!(id: params[:id])
      #   picks = team.picks_dataset
      #   json picks
      # end

    end
  end
end