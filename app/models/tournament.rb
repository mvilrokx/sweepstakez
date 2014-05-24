module Sweepstakes
  module Models
    class Tournament < Sequel::Model
      one_to_many :groups, :on_delete => :cascade
    end
  end
end