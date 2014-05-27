module Sweepstakes
  module Models
    class TournamentParticipant < Sequel::Model
      many_to_one :group
      many_to_one :country
    end
  end
end