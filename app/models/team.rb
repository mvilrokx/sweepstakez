module Sweepstakes
  module Models
    class Team < Sequel::Model
      many_to_one :user
      many_to_one :tournament
      one_to_many :picks, :on_delete => :cascade

      dataset_module do
        def ordered
          order(:created_at.desc)
        end

        def for_user(user)
          where(:user_id => user.id)
        end
      end

      def tournament_name
        tournament && tournament.name
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:              id,
          name:            name,
          tournament_id:   tournament_id,
          tournament_name: tournament_name
        }
      end

    end
  end
end