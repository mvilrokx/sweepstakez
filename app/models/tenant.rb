module Sweepstakes
  module Models
    class Tenant < Sequel::Model
      cattr_accessor :current_id

      one_to_many :users
      one_to_many :teams
      one_to_many :picks

      def as_json(options = nil)
        {
          id:        id,
          name:      name,
          subdomain: subdomain,
          users:     users
        }
      end

    end
  end
end