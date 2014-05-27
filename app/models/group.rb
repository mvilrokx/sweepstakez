module Sweepstakes
  module Models
    class Group < Sequel::Model
      many_to_one :tournament
      one_to_many :tournament_participants
      many_to_many :countries, :join_table=>:tournament_participants
    end
  end
end