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

      end

      def validate
        super
        errors.add(:name, 'tournament already started') if tournament.started?
      end

      def before_destroy
        super
        return false if tournament.started?
      end

      def tournament_name
        tournament && tournament.name
      end

      def tournament_started?
        tournament && tournament.started?
      end

      def points
        points = 0
        picks.each do |pick|
          points = points + pick.points
        end
        points
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