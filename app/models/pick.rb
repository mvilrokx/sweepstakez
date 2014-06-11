module Sweepstakes
  module Models
    class Pick < Sequel::Model
      many_to_one :team
      many_to_one :tournament_participant
      many_to_one :tenant

      dataset_module do
        def ordered
          order(:position.asc)
        end

        def for_user(user)
          where(:user_id => user.id)
        end

        def for_tenant(tenant)
          where(:tenant_id => tenant.id)
        end
      end

      def validate
        super
        validates_unique [:team_id, :tournament_participant_id]
        errors.add(:name, 'tournament already started') if team.tournament_started?
      end

      def before_destroy
        super
        return false if team.tournament_started?
      end

      def country_name
        tournament_participant && tournament_participant.country_name
      end

      def country_code
        tournament_participant && tournament_participant.country_code
      end

      def country_code3
        tournament_participant && tournament_participant.country_code3
      end

      def flag_url
        tournament_participant && tournament_participant.flag_url
      end

      def team_name
        team && team.name
      end

      def group_name
        tournament_participant && tournament_participant.group_name
      end

      def points
        tournament_participant.points * (9 - position)
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:                        id,
          team_id:                   team_id,
          team_name:                 team_name,
          tournament_participant_id: tournament_participant_id,
          country_name:              country_name,
          country_code:              country_code,
          country_code3:             country_code3,
          position:                  position,
          flag_url:                  flag_url,
          group_name:                group_name,
          points:                    points
        }
      end

    end
  end
end