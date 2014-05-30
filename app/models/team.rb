module Sweepstakes
  module Models
    class Team < Sequel::Model
      many_to_one :user
      many_to_one :tournament
      one_to_many :picks,:on_delete => :cascade

      dataset_module do
        def ordered
          order(:created_at.desc)
        end

        def for_user(user)
          where(:user_id => user.id)
        end
      end

    end
  end
end