module Sweepstakes
  module Models
    class Fixture < Sequel::Model
      many_to_one :home_team, :class => TournamentParticipant, :key => :home_tournament_participant_id
      many_to_one :away_team, :class => TournamentParticipant, :key => :away_tournament_participant_id

      dataset_module do
        def ordered
          order(:kickoff.desc)
        end
      end

      serialize_attributes :json, :result

      def as_json(options = nil)
        {
          id:        id,
          home_team: home_team,
          away_team: away_team,
          result:    result
        }
      end
    end
  end
end
