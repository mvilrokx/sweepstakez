require './app'
require 'tzinfo'

timestamp = Time.now

# Start game is in Sao Paulo, End game is in Rio De Janeiro which is in the same timezone.
tz = TZInfo::Timezone.get('America/Sao_Paulo')

# Clean Up
TournamentParticipant.where('created_at < ?', Time.now).delete if Group.all.count > 0
Group.where('created_at < ?', Time.now).delete if Group.all.count > 0
Tournament.where('created_at < ?', Time.now).delete if Tournament.all.count > 0
Country.where('created_at < ?', Time.now).delete if Country.all.count > 0

print "Loading countries from geonames.org API ...\n"
# Populate all countries from http://api.geonames.org/countryInfoJSON?username=demo
# https://devcenter.heroku.com/articles/config-vars to see how to set this on heroku
# e.g. $heroku config:set GEONAMES_USERNAME=johndoe
response = HTTParty.get("http://api.geonames.org/countryInfoJSON?username=#{ENV['GEONAMES_USERNAME']}")
response['geonames'].each do |country|
  print '.'
  languages = country['languages'].split(",")
  # TODO: Should use upsert instead!
  Country.insert(
    :country_code => country['countryCode'],
    :country_name => country['countryName'],
    :iso_numeric => country['isoNumeric'],
    :iso_alpha3 => country['isoAlpha3'],
    :fips_code => country['fipsCode'],
    :continent => country['continent'],
    :continent_name => country['continentName'],
    :capital => country['capital'],
    :area_in_sq_km => country['areaInSqKm'].to_f,
    :population => country['population'],
    :currency_code => country['currencyCode'],
    :languages => '{' + languages.join(', ') + '}',
    :geoname_id => country['geonameId'],
    :west => country['west'],
    :north => country['north'],
    :east => country['east'],
    :south => country['south'],
    :created_at => timestamp,
    :updated_at => timestamp
  )
end

# Turns out England isn't a real country ...
# All these values are MADE UP, just like the country apparently...
Country.insert(
  :country_code => "",
  :country_name => "England",
  :iso_numeric => "900",
  :iso_alpha3 => "ENG",
  :fips_code => "",
  :continent => "EU",
  :continent_name => "Europe",
  :capital => "London",
  :area_in_sq_km => 0.to_f,
  :population => 0,
  :currency_code => "GBP",
  :languages => '{"en-GB"}',
  :geoname_id => 2635167,
  :west => 0,
  :north => 0,
  :east => 0,
  :south => 0,
  :created_at => timestamp,
  :updated_at => timestamp
)

# TODO Add other fake countries like Wales, Scotland and Northern Ireland

# TODO This should really come from a file

# Start game is in Sao Paulo, End game is in Rio De Janeiro which is in the same timezone.
# Find these using TZInfo::Country.get('<2-country-code>').zone_identifiers in irb
tz = TZInfo::Timezone.get('America/Sao_Paulo')
fifa_wc_2014 = Tournament.insert(
  :name => '2014 FIFA WORLD CUP',
  :description => '',
  :starts_at => tz.local_to_utc(Time.local(2014, 6, 12, 17, 00, 00)),
  :ends_at => tz.local_to_utc(Time.local(2014, 7, 13, 18, 00, 00)),
  :host_countries => '{"BRAZIL"}',
  :created_at => timestamp,
  :updated_at => timestamp
)

# TODO This should really come from a file
('A'..'H').each do |name|
  Group.insert(
    :name => name,
    :tournament_id => fifa_wc_2014,
    :created_at => timestamp,
    :updated_at => timestamp
  )
end

tz = TZInfo::Timezone.get('Europe/Warsaw')
tourny = Tournament.insert(
  :name => '2012 UEFA EURO',
  :description => '',
  :starts_at => tz.local_to_utc(Time.local(2012, 6, 8, 17, 00, 00)),
  :ends_at => tz.local_to_utc(Time.local(2012, 7, 1, 18, 00, 00)),
  :host_countries => '{"POLAND", "UKRAIN"}',
  :created_at => timestamp,
  :updated_at => timestamp
)

tz = TZInfo::Timezone.get('Europe/Paris')
tourny = Tournament.insert(
  :name => '2016 UEFA EURO',
  :description => '',
  :starts_at => tz.local_to_utc(Time.local(2016, 6, 10, 21, 00, 00)),
  :ends_at => tz.local_to_utc(Time.local(2016, 7, 10, 23, 00, 00)),
  :host_countries => '{"FRANCE"}',
  :created_at => timestamp,
  :updated_at => timestamp
)


tournamentFiles = ["db/2014 FIFA WORLD CUP.txt"]
# TODO: Get tournament name from filename
tournament = Tournament.where(:name => '2014 FIFA WORLD CUP').first
# puts tournament.groups

tournamentFiles.each do |tournamentFile|
  File.open(tournamentFile) do |participants|
    print "\nLoading participants from file " + tournamentFile
    participants.read.each_line do |participant|
      group_name, country_name = participant.chomp.strip.split("|")
      puts group_name + ' - ' + country_name
      begin
        # puts tournament.groups_dataset.select(:id).where(:name => group_name).first.id
        # puts Country.select(:id).where(:country_name => country_name).first.id
        participant = TournamentParticipant.insert(
          :group_id => tournament.groups_dataset.select(:id).where(:name => group_name).first.id,
          :country_id => Country.select(:id).where(:country_name => country_name).first.id,
          :created_at => timestamp,
          :updated_at => timestamp
        )
        print "."
      rescue Exception => e
        if group_name != "group name" && country_name != "country name"
          puts "\nERROR WITH " + group_name + ' ERROR = ' + e.message
        else
          puts "\nWarning: Please remove the column headers/titles from your file"
        end
      end
    end
  end
end

