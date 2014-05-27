module Sweepstakes
  module Models
    class Country < Sequel::Model
      one_to_many :tournament_participants
    end
  end
end