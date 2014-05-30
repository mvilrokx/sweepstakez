module Sweepstakes
  module Models
    class Pick < Sequel::Model
      many_to_one :team
      many_to_one :tournament_participant

      dataset_module do
        def ordered
          order(:created_at.desc)
        end
      end

    end
  end
end