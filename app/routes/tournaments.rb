module Sweepstakes
  module Routes
    class Tournaments < Base

      # get '/tournaments/:tournament' do
      #   content_type :json
      #   t = Tournament.where(:name => params[:tournament]).first
      #   groups[params[:tournament]] = {}

      #   t.groups.each do |group|
      #     groups[params[:tournament]][group.name] = []
      #     group.countries.each do |country|
      #       puts group.name + " - " + country.country_name
      #       groups[params[:tournament]][group.name].push(country.country_name)
      #     end
      #   end
      #   groups[params[:tournament]].to_json
      # end

      get '/tournaments/:name/ranking' do
        tournament = Tournament.where(name: params[:name]).first!
        json tournament, teams: :teams
      end

      get '/tournaments/:name' do
        tournament = Tournament.where(name: params[:name]).first!
        json tournament
      end

      # get '/tournaments/:id' do
      #   tournament = Tournament.first!(id: params[:id])
      #   json tournament
      # end

      # get '/tournaments/:tournament_name' do
      #   t = Tournament.where(:name => params[:tournament_name]).first
      #   json t
      # end

      get '/tournaments' do
        json Tournament.all
      end

    end
  end
end