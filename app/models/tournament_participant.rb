module Sweepstakes
  module Models
    class TournamentParticipant < Sequel::Model
      many_to_one :group
      many_to_one :country
      one_to_many :picks, :on_delete => :cascade

      def country_name
        country && country.country_name
      end

      def flag_url
        country && country.flag_url
      end

      def group_name
        group && group.name
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:           id,
          country_name: country_name,
          group_name:   group_name,
          country:      country
        }
      end


    end
  end
end