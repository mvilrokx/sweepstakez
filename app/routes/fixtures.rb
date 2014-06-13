module Sweepstakes
  module Routes
    class Fixtures < Base

      # Query all
      get '/fixtures' do
        json Fixture.ordered.all
      end

      # Query one
      get '/fixtures/:id' do
        json Fixture.first!(id: params[:id])
      end

      # Create
      post '/fixtures', :auth => true do
        if current_user.admin?
          fixture      = Fixture.new
          fixture.set_fields(params, [
            :home_tournament_participant_id,
            :away_tournament_participant_id,
            :kickoff,
            :venue,
            :result])

          fixture.save
          json fixture
        else
          error 403
        end
      end

      # Update
      put '/fixtures/:id', :auth => true do
        if current_user.admin?
          fixture = Fixture.first!(id: params[:id])
          fixture.set_fields(params, [
            # :home_tournament_participant_id,
            # :away_tournament_participant_id,
            # :kickoff,
            # :venue,
            :result])

          fixture.save
          json fixture
        else
          error 403
        end
      end

      # Delete
      delete '/fixtures/:id', :auth => true do
        fixture = Fixture.first!(id: params[:id])

        fixture.destroy
        json fixture
      end

    end
  end
end