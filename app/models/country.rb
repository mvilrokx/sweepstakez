module Sweepstakes
  module Models
    class Country < Sequel::Model
      one_to_many :tournament_participants

      def flag_url
        "http://www.geonames.org/flags/x/#{country_code.downcase}.gif"
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:           id,
          country_code: country_code,
          country_name: country_name,
          flag_url:     flag_url
        }
      end
    end
  end
end
