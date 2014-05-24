module Sweepstakes
  module Models
    class Group < Sequel::Model
      many_to_one :tournament
    end
  end
end