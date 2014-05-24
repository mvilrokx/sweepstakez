Sequel.default_timezone = :utc

module Sweepstakes
  module Models
    autoload :Tournament, 'app/models/tournament'
    autoload :Group, 'app/models/group'
  end
end