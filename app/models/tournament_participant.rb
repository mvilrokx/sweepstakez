module Sweepstakes
  module Models
    class TournamentParticipant < Sequel::Model
      many_to_one :group
      many_to_one :country
      one_to_many :picks, :on_delete => :cascade
    end
  end
end