require './app'
require 'tzinfo'

timestamp = Time.now

# Clean Up
# Tenant.where('created_at < ?', Time.now).delete if Tenant.all.count > 0
# TournamentParticipant.where('created_at < ?', Time.now).delete if TournamentParticipant.all.count > 0
# Group.where('created_at < ?', Time.now).delete if Group.all.count > 0
# Tournament.where('created_at < ?', Time.now).delete if Tournament.all.count > 0
# Country.where('created_at < ?', Time.now).delete if Country.all.count > 0
# Fixture.where('created_at < ?', Time.now).delete if Fixture.all.count > 0

print "Loading countries from geonames.org API ...\n"
# Populate all countries from http://api.geonames.org/countryInfoJSON?username=demo
# https://devcenter.heroku.com/articles/config-vars to see how to set this on heroku
# e.g. $heroku config:set GEONAMES_USERNAME=johndoe
response = HTTParty.get("http://api.geonames.org/countryInfoJSON?username=#{ENV['GEONAMES_USERNAME']}")
# Turns out England isn't a real country ...
# All these values are MADE UP, just like the country apparently...
response['geonames'].push ({
  "countryCode"   => "",
  "countryName"   => "England",
  "isoNumeric"    => "900",
  "isoAlpha3"     => "ENG",
  "fipsCode"      => "",
  "continent"     => "EU",
  "continentName" => "Europe",
  "capital"       => "London",
  "areaInSqKm"    => 0,
  "population"    => 0,
  "currencyCode"  => "GBP",
  "languages"     => "en-GB",
  "geonameId"     => 2635167,
  "west"          => 0,
  "north"         => 0,
  "east"          => 0,
  "south"         => 0
})
# TODO Add other fake countries like Wales, Scotland and Northern Ireland

response['geonames'].each do |country|
  print '.'
  languages = country['languages'].split(",")
  # Upsert
  c = Country.where(:country_code => country['countryCode'])
  if 1 != c.update( :country_name => country['countryName'],
                    :iso_numeric    => country['isoNumeric'],
                    :iso_alpha3     => country['isoAlpha3'],
                    :fips_code      => country['fipsCode'],
                    :continent      => country['continent'],
                    :continent_name => country['continentName'],
                    :capital        => country['capital'],
                    :area_in_sq_km  => country['areaInSqKm'].to_f,
                    :population     => country['population'],
                    :currency_code  => country['currencyCode'],
                    :languages      => '{' + languages.join(', ') + '}',
                    :geoname_id     => country['geonameId'],
                    :west           => country['west'],
                    :north          => country['north'],
                    :east           => country['east'],
                    :south          => country['south']) then
    Country.insert(
      :country_code   => country['countryCode'],
      :country_name   => country['countryName'],
      :iso_numeric    => country['isoNumeric'],
      :iso_alpha3     => country['isoAlpha3'],
      :fips_code      => country['fipsCode'],
      :continent      => country['continent'],
      :continent_name => country['continentName'],
      :capital        => country['capital'],
      :area_in_sq_km  => country['areaInSqKm'].to_f,
      :population     => country['population'],
      :currency_code  => country['currencyCode'],
      :languages      => '{' + languages.join(', ') + '}',
      :geoname_id     => country['geonameId'],
      :west           => country['west'],
      :north          => country['north'],
      :east           => country['east'],
      :south          => country['south'],
      :created_at     => timestamp,
      :updated_at     => timestamp
    )
  end
end

# TODO This should really come from a file

# Start game is in Sao Paulo, End game is in Rio De Janeiro which is in the same timezone.
# Find these using TZInfo::Country.get('<2-country-code>').zone_identifiers in irb
print "\nLoading Tournaments and Groups (these are hard coded in seeds.rb) ...\n"

tz = TZInfo::Timezone.get('America/Sao_Paulo')

fifa_wc_2014 = Tournament.where(:name => '2014 FIFA WORLD CUP')
if 1 != fifa_wc_2014.update(:description => '',
                            :starts_at => tz.local_to_utc(Time.local(2014, 6, 12, 17, 00, 00)),
                            :ends_at => tz.local_to_utc(Time.local(2014, 7, 13, 18, 00, 00)),
                            :host_countries => '{"BRAZIL"}') then
  fifa_wc_2014 = Tournament.insert(
    :name => '2014 FIFA WORLD CUP',
    :description => '',
    :starts_at => tz.local_to_utc(Time.local(2014, 6, 12, 17, 00, 00)),
    :ends_at => tz.local_to_utc(Time.local(2014, 7, 13, 18, 00, 00)),
    :host_countries => '{"BRAZIL"}',
    :created_at => timestamp,
    :updated_at => timestamp
  )
else
  fifa_wc_2014 = Tournament.select(:id).where(:name => '2014 FIFA WORLD CUP').naked.first[:id]
end

puts fifa_wc_2014

# TODO This should really come from a file
('A'..'H').each do |name|
  g = Group.where(:name => name, :tournament_id => fifa_wc_2014).first
  if !g
    Group.insert(
      :name => name,
      :tournament_id => fifa_wc_2014,
      :created_at => timestamp,
      :updated_at => timestamp
    )
  end
end


tz = TZInfo::Timezone.get('Europe/Warsaw')
tourny = Tournament.where(:name => '2012 UEFA EURO')

if 1 != tourny.update(:description => '',
                      :starts_at => tz.local_to_utc(Time.local(2012, 6, 8, 17, 00, 00)),
                      :ends_at => tz.local_to_utc(Time.local(2012, 7, 1, 18, 00, 00)),
                      :host_countries => '{"POLAND", "UKRAIN"}') then
  tourny = Tournament.insert(
    :name => '2012 UEFA EURO',
    :description => '',
    :starts_at => tz.local_to_utc(Time.local(2012, 6, 8, 17, 00, 00)),
    :ends_at => tz.local_to_utc(Time.local(2012, 7, 1, 18, 00, 00)),
    :host_countries => '{"POLAND", "UKRAIN"}',
    :created_at => timestamp,
    :updated_at => timestamp
  )
end

tz = TZInfo::Timezone.get('Europe/Paris')
tourny = Tournament.where(:name => '2016 UEFA EURO')

if 1 != tourny.update(:description => '',
                      :starts_at => tz.local_to_utc(Time.local(2016, 6, 10, 21, 00, 00)),
                      :ends_at => tz.local_to_utc(Time.local(2016, 7, 10, 23, 00, 00)),
                      :host_countries => '{"FRANCE"}') then
  tourny = Tournament.insert(
    :name => '2016 UEFA EURO',
    :description => '',
    :starts_at => tz.local_to_utc(Time.local(2016, 6, 10, 21, 00, 00)),
    :ends_at => tz.local_to_utc(Time.local(2016, 7, 10, 23, 00, 00)),
    :host_countries => '{"FRANCE"}',
    :created_at => timestamp,
    :updated_at => timestamp
  )
end

tournamentFiles = ["db/2014 FIFA WORLD CUP.txt"]
# TODO: Get tournament name from filename
tournament = Tournament.where(:name => '2014 FIFA WORLD CUP').first
tournamentFiles.each do |tournamentFile|
  File.open(tournamentFile) do |participants|
    print "\nLoading participants from file " + tournamentFile
    participants.read.each_line do |participant|
      group_name, country_name = participant.chomp.strip.split("|")
      puts group_name + ' - ' + country_name
      begin
        tp = TournamentParticipant.where(
          :group_id => tournament.groups_dataset.select(:id).where(:name => group_name),
          :country_id => Country.select(:id).where(:country_name => country_name),
        ).first
        if !tp
          TournamentParticipant.insert(
            :group_id => tournament.groups_dataset.select(:id).where(:name => group_name).first.id,
            :country_id => Country.select(:id).where(:country_name => country_name).first.id,
            :created_at => timestamp,
            :updated_at => timestamp
          )
          print "."
        end
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


tenant = Tenant.where(name: "UX", subdomain: "ux").first
if !tenant
  Tenant.create(name: "UX", subdomain: "ux")
end

tenant = Tenant.where(name: "HCM", subdomain: "hcm").first
if !tenant
  Tenant.create(name: "HCM", subdomain: "hcm")
end

tenant = Tenant.where(name: "KineMed", subdomain: "kinemed").first
if !tenant
  Tenant.create(name: "KineMed", subdomain: "kinemed")
end

File.open("db/2014_WC_FIXTURES.txt") do |fixtures|
  fixtures.read.each_line do |fixture|
    kickoff, home, away, venue, tz = fixture.chomp.strip.split("|")

    begin
      kickoff = Time.parse(kickoff)
      kickoff = Time.new(kickoff.year,kickoff.month,kickoff.day,kickoff.hour,kickoff.min,kickoff.sec,tz)

      puts home + ' vs ' + away
      home_team = Country.where(:country_name => home).first
      away_team = Country.where(:country_name => away).first


      f = Fixture.where(
        :home_tournament_participant_id => TournamentParticipant.where(:country => home_team).first.id,
        :away_tournament_participant_id => TournamentParticipant.where(:country => away_team).first.id
        )
      if 1 != f.update(:venue => venue,
                       :kickoff => kickoff) then
        f = Fixture.insert(
          :kickoff => kickoff,
          :home_tournament_participant_id => TournamentParticipant.where(:country => home_team).first.id,
          :away_tournament_participant_id => TournamentParticipant.where(:country => away_team).first.id,
          :venue => venue,
          :created_at => timestamp,
          :updated_at => timestamp
        )
      end
      print "."
    rescue Exception => e
      if kickoff != "kickoff" && home != "home" && away != "away" && venue != "venue"
        puts "\nERROR WITH " + kickoff + ' ERROR = ' + e.message
      else
        puts "\nWarning: Please remove the column headers/titles from your file"
      end
    end
  end
end
