module Sweepstakes
  module Models
    class Group < Sequel::Model
      many_to_one :tournament
      one_to_many :tournament_participants, :on_delete => :cascade
      many_to_many :countries, :join_table=>:tournament_participants

      def tournament_name
        tournament && tournament.name
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:                      id,
          name:                    name,
          tournament_participants: tournament_participants
          # countries:               countries
        }
      end

    end
  end
end