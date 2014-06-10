module Sweepstakes
  module Models
    class Team < Sequel::Model
      many_to_one :user
      many_to_one :tournament
      one_to_many :picks
      many_to_one :tenant

      dataset_module do
        def ordered
          order(:created_at.desc)
        end

        def for_user(user)
          where(:user_id => user.id)
        end

        def for_tenant(tenant)
          where(:tenant_id => tenant.id)
        end

        # def tenant
        #   where(:tenant_id => Tenant.current_id)
        # end
      end

      # set_dataset(self.tenant) # default scope!

      def tournament_name
        tournament && tournament.name
      end

      def points
        points = 0
        picks.each do |pick|
          pick.tournament_participant.home_team.each do |fixture|
            if fixture.result
              # Each time one of your teams scores a goal, they score 1 point for you.
              points = points + fixture.result[:home_score]
              # Each win scores 3 points for you.
              if fixture.result[:home_score] > fixture.result[:away_score]
                points = points + 3
              end
              # In the preliminary group stage, a draw earns 1 point for you.
              if fixture.result[:home_score] = fixture.result[:away_score] && fixture.result[:group_stage] = 'Y'
                points = points + 1
              end
            end
          end
          pick.tournament_participant.away_team.each do |fixture|
            if fixture.result
              # Each time one of your teams scores a goal, they score 1 point for you.
              points = points + fixture.result[:away_score]
              # Each win scores 3 points for you.
              if fixture.result[:away_score] > fixture.result[:home_score]
                points = points + 3
              end
              # In the preliminary group stage, a draw earns 1 point for you.
              if fixture.result[:away_score] = fixture.result[:home_score] && fixture.result[:group_stage] = 'Y'
                points = points + 1
              end
            end
          end
          # This is then multiplied up by the rank chosen.
          points = points * pick.position
        end
        points
        # Goals scored in a penalty shoot out do not count - silver and golden goals do count. There are no other special bonuses.
      end

      def as_json(options = nil)
        # user = (options || {})[:user]
        {
          id:              id,
          name:            name,
          tournament_id:   tournament_id,
          tournament_name: tournament_name,
          picks:           picks,
          user:            user,
          points:          points
        }
      end

    end
  end
end