Sequel.default_timezone = :utc

module Sweepstakes
  module Models
    autoload :Tournament, 'app/models/tournament'
    autoload :Group, 'app/models/group'
    autoload :Country, 'app/models/country'
  end
end