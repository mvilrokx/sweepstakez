require './app'
require 'tzinfo'

timestamp = Time.now

# Start game is in Sao Paulo, End game is in Rio De Janeiro which is in the same timezone.
tz = TZInfo::Timezone.get('America/Sao_Paulo')

# Clean Up
Group.where('created_at < ?', Time.now).delete if Group.all.count > 0
Tournament.where('created_at < ?', Time.now).delete if Tournament.all.count > 0
Country.where('created_at < ?', Time.now).delete if Country.all.count > 0

tourny = Tournament.insert(
  :name => '2014 FIFA WORLD CUP',
  :description => '',
  :starts_at => tz.local_to_utc(Time.local(2014, 6, 12, 17, 00, 00)),
  :ends_at => tz.local_to_utc(Time.local(2014, 7, 13, 18, 00, 00)),
  :countries => '{"BRAZIL"}',
  :created_at => timestamp,
  :updated_at => timestamp
)

('A'..'H').each do |name|
  Group.insert(
    :name => name,
    :tournament_id => tourny,
    :created_at => timestamp,
    :updated_at => timestamp
  )
end

print "Loading countries from geonames.org API ...\n"
#Populate all countries from http://api.geonames.org/countryInfoJSON?username=demo
response = HTTParty.get('http://api.geonames.org/countryInfoJSON?username=mvilrokx')
# puts response.body, response.code #, response.message, response.headers.inspect
response['geonames'].each do |country|
  print '.'
  languages = country['languages'].split(",")
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