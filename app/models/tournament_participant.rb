module Sweepstakes
  module Models
    class TournamentParticipant < Sequel::Model
      many_to_one :group
      many_to_one :country
      one_to_many :picks
      one_to_many :home_team, :class => Fixture, :key => :home_tournament_participant_id
      one_to_many :away_team, :class => Fixture, :key => :away_tournament_participant_id

      def country_name
        country && country.country_name
      end

      def country_code
        country && country.country_code
      end

      def country_code3
        country && country.iso_alpha3
      end

      def flag_url
        country && country.flag_url
      end

      def group_name
        group && group.name
      end

      def points
        points = 0
        home_team.each do |fixture|
          points = points + (fixture.home_team_points||0)
        end
        away_team.each do |fixture|
          points = points + (fixture.away_team_points||0)
        end
        points
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