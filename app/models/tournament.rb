module Sweepstakes
  module Models
    class Tournament < Sequel::Model
      one_to_many :groups, :on_delete => :cascade
      one_to_many :teams, :on_delete => :cascade

      dataset_module do
        def active
          where{ends_at >= Time.now}.order(:ends_at.asc)
        end
      end

      def as_json(options = nil)
        user = (options || {})[:user]
        {
          id:             id,
          name:           name,
          description:    description,
          starts_at:      starts_at,
          ends_at:        ends_at,
          host_countries: host_countries,
          groups:         groups
        }
      end

    end
  end
end