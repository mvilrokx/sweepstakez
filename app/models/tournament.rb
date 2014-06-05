module Sweepstakes
  module Models
    class Tournament < Sequel::Model
      one_to_many :groups
      one_to_many :teams

      dataset_module do
        def active
          where{ends_at >= Time.now}.order(:ends_at.asc)
        end
      end

      def as_json(options = nil)
        # user = (options || {})[:user]
        options ||= {}

        result = {
          id:             id,
          name:           name,
          description:    description,
          starts_at:      starts_at,
          ends_at:        ends_at,
          host_countries: host_countries,
          groups:         groups
        }

        if options[:teams] then
          result.delete(:groups)
          result.delete(:host_countries)
          result.merge!(teams: teams)
        end
        result
      end

    end
  end
end