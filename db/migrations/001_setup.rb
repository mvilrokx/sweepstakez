# Make the database exists before you run this command
# e.g. from the CLI:
# $createdb sweepstakes_development

Sequel.migration do
  change do
    # This statement breaks the automatic rollback (reverse migration)
    run %{
      CREATE EXTENSION IF NOT EXISTS "uuid-ossp" WITH SCHEMA public;
    }

    create_table(:tournaments) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      column :name, "text"
      column :description, "text"
      column :starts_at, "timestamp with time zone"
      column :ends_at, "timestamp with time zone"
      column :countries, "text[]"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :name, :unique=>true
      index :iid, :unique=>true
    end

    create_table(:groups) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      column :name, "text"
      foreign_key :tournament_id, :tournaments, :type=>"uuid", :key => [:id]
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
      index :tournament_id #, :name], :unique=>true
    end

    create_table(:countries) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      column :country_code, "text", :null => false
      column :country_name, "text"
      column :iso_numeric, "integer", :null => false
      column :iso_alpha3, "text", :null => false
      column :fips_code, "text"
      column :continent, "text", :null => false
      column :continent_name, "text"
      column :capital, "text"
      column :area_in_sq_km, "float"
      column :population, "integer"
      column :currency_code, "text", :null => false
      column :languages, "text[]"
      column :geoname_id, "integer"
      column :west, "float"
      column :north, "float"
      column :east, "float"
      column :south, "float"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
      index :country_code, :unique=>true
      index :iso_numeric, :unique=>true
      index :iso_alpha3, :unique=>true
    end

    create_table(:tournament_participants) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      foreign_key :group_id, :groups, :type=>"uuid", :key => [:id]
      foreign_key :country_id, :countries, :type=>"uuid", :key => [:id]
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
      index [:group_id, :country_id], :unique=>true
    end

    create_table(:users) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      column :uid, "text"
      column :provider, "text"
      column :handle, "text"
      column :about, "text"
      column :email, "text"
      column :url, "text"
      column :twitter, "text"
      column :karma, "integer", :default=>0
      column :name, "text"
      column :auth, "json"
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"
      column :admin, "boolean", :default=>false
      column :registered, "boolean"
      foreign_key :parent_id, :users, :type=>"uuid", :key=>[:id]
      column :invites_count, "integer", :default=>0
      column :github, "text"
      column :secret, "text"
      column :manifesto, "boolean", :default=>false

      primary_key [:id]

      index [:handle]
      index [:iid], :unique=>true
      index [:uid], :unique=>true
    end

    create_table(:teams) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      column :name, "text"
      foreign_key :user_id, :users, :type=>"uuid", :key => [:id]
      foreign_key :tournament_id, :tournaments, :type=>"uuid", :key => [:id]
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
    end

    create_table(:picks) do
      column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
      column :iid, :serial, :null=>false
      foreign_key :team_id, :teams, :type=>"uuid", :key => [:id]
      foreign_key :tournament_participant_id, :tournament_participants, :type=>"uuid", :key => [:id]
      column :created_at, "timestamp without time zone"
      column :updated_at, "timestamp without time zone"

      primary_key [:id]

      index :iid, :unique=>true
    end

  end
end

