require 'active_support/core_ext/string'
require 'active_support/core_ext/array'
require 'active_support/core_ext/hash'

Sequel.default_timezone = :utc

Sequel.extension :core_extensions
# Sequel.extension :pg_array
# Sequel.extension :pg_array_ops

Sequel::Model.plugin :timestamps
Sequel::Model.plugin :serialization

Sequel::Plugins::Serialization.register_format(:json,
  lambda{|v| v.to_json },
  lambda{|v| JSON.parse(v, :symbolize_names => true) }
)

Sequel::Plugins::Serialization.register_format(:pg_uuid_array,
  lambda{|v| Sequel::Postgres::PGArray.new(v, :uuid) },
  lambda{|v| Sequel::Postgres::PGArray::Parser.new(v).parse }
)

module Sweepstakes
  module Models
    autoload :User, 'app/models/user'
    autoload :Tournament, 'app/models/tournament'
    autoload :Group, 'app/models/group'
    autoload :TournamentParticipant, 'app/models/tournament_participant'
    autoload :Country, 'app/models/country'
  end
end