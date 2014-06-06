module Sweepstakes
  module Models
    class Country < Sequel::Model
      one_to_many :tournament_participants

      def flag_url
        if iso_alpha3 == "ENG" then
          "http://flaglane.com/download/english-flag/english-flag-small.png"
        else
          "http://www.geonames.org/flags/x/#{country_code.downcase}.gif"
        end
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
