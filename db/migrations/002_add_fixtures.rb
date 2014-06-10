Sequel.migration do
  change do

    create_table(:fixtures) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      foreign_key :home_tournament_participant_id, :tournament_participants, :type=>"uuid", :key => [:id], :on_delete => :cascade
      foreign_key :away_tournament_participant_id, :tournament_participants, :type=>"uuid", :key => [:id], :on_delete => :cascade

      column :kickoff, "timestamp with time zone"
      column :venue, "text"

      column :result, "json"

      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
      index [:home_tournament_participant_id, :away_tournament_participant_id], :unique=>true
    end

  end
end

