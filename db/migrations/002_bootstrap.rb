require 'tzinfo'

Sequel.migration do
  up do

    timestamp = Time.now

    # Start game is in Sao Paulo, End game is in Rio De Janeiro which is in the same timezone.
    tz = TZInfo::Timezone.get('America/Sao_Paulo')

    self[:tournaments].insert(
      :name => '2014 FIFA WORLD CUP',
      :description => '',
      :starts_at => tz.local_to_utc(Time.local(2014, 6, 12, 17, 00, 00)),
      :ends_at => tz.local_to_utc(Time.local(2014, 7, 13, 18, 00, 00)),
      :countries => '{"BRAZIL"}',
      :created_at => timestamp,
      :updated_at => timestamp
    )
  end
end