module Sweepstakes
  module Routes
    class Tournaments < Base
      groups = {}

      # error Models::NotFound do
      #   error 404
      # end

      get '/tournaments/:tournament' do
        content_type :json
        t = Tournament.where(:name => params[:tournament]).first
        groups[params[:tournament]] = {}

        t.groups.each do |group|
          groups[params[:tournament]][group.name] = []
          group.countries.each do |country|
            puts group.name + " - " + country.country_name
            groups[params[:tournament]][group.name].push(country.country_name)
          end
        end
        groups[params[:tournament]].to_json
      end

    end
  end
end