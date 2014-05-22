module Sweepstakes
  module Routes
    class Tournaments < Base
      groups = {
        '2014 FIFA WORLD CUP' => {
          'A' => ['Brazil', 'Croatia', 'Mexico', 'Cameroon'],
          'B' => ['Spain', 'Netherlands', 'Chile', 'Australia'],
          'C' => ['Colombia', 'Greece', 'Côte D\'Ivoire', 'Japan'],
          'D' => ['Uruguay', 'Costa Rica', 'England', 'Italy'],
          'E' => ['Switzerland', 'Ecuador', 'France', 'Honduras'],
          'F' => ['Argentina', 'Bosnia and Herzegovina', 'Iran', 'Nigeria'],
          'G' => ['Germany', 'Portugal', 'Ghana', 'USA'],
          'H' => ['Belgium', 'Algeria', 'Russia', 'Korea Republic']
        }
      };

      # error Models::NotFound do
      #   error 404
      # end

      get '/groups/:tournament' do
        content_type :json
        groups[params[:tournament]].to_json
      end

      get '/groups' do
        content_type :json
        groups.to_json
      end
    end
  end
end