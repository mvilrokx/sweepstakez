module Sweepstakes
  module Routes
    autoload :Users, 'app/routes/users'
    autoload :Base, 'app/routes/base'
    autoload :Tournaments, 'app/routes/tournaments'
    autoload :Countries, 'app/routes/countries'
    autoload :Teams, 'app/routes/teams'
    autoload :Picks, 'app/routes/picks'
  end
end