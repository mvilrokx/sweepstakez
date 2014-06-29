module Sweepstakes
  module Models
    class Fixture < Sequel::Model
      many_to_one :home_team, :class => TournamentParticipant, :key => :home_tournament_participant_id
      many_to_one :away_team, :class => TournamentParticipant, :key => :away_tournament_participant_id

      dataset_module do
        def ordered
          order(:kickoff.asc)
        end
      end

      serialize_attributes :json, :result

      def group_stage?
        result[:group_stage] == 'Y'
      end

      # TODO: This is just an approximation,
      #       overtime and penalty shootouts would make this wrong
      def live?
        Time.now.utc.between?(kickoff, kickoff + (90*60)+(15*60))
      end

      def home_country_name
        home_team && home_team.country_name
      end

      def away_country_name
        away_team && away_team.country_name
      end

      def home_team_points
        if result
          points = calc_points(result[:home_score].to_i, result[:away_score].to_i)
        end
        points
      end

      def away_team_points
        if result
          points = calc_points(result[:away_score].to_i, result[:home_score].to_i)
        end
        points
      end

      def as_json(options = nil)
        {
          id:               id,
          home_team:        home_team,
          home_team_points: home_team_points,
          away_team:        away_team,
          away_team_points: away_team_points,
          venue:            venue,
          kickoff:          kickoff,
          live:             live?,
          result:           result
        }
      end

      def calc_points(my_score, other_score)
        points = 0
        # Each time one of your teams scores a goal, they score 1 point for you.
        points = points + my_score
        # Each win scores 3 points for you.
        if my_score > other_score
          points = points + 3
        end
        # In the group stage, a draw earns 1 point for you.
        if group_stage?
          if my_score == other_score
            points = points + 1
          end
        else # there are no draws in the elimination round
          if my_score == other_score # so there must have been a penalty shootout
            if result[:home_penalty].to_i > result[:away_penalty].to_i
              points = points + 3
            end
          end
        end
        points
      end

    end
  end
end
