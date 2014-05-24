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

      index :name
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
      index :tournament_id
    end

    # create_table(:users) do
    #   column :id, "uuid", :default=>Sequel::LiteralString.new("uuid_generate_v4()"), :null=>false
    #   column :iid, :serial, :null=>false
    #   column :uid, "text"
    #   column :provider, "text"
    #   column :handle, "text"
    #   column :about, "text"
    #   column :email, "text"
    #   column :url, "text"
    #   column :twitter, "text"
    #   column :karma, "integer", :default=>0
    #   column :name, "text"
    #   column :auth, "json"
    #   column :created_at, "timestamp without time zone"
    #   column :updated_at, "timestamp without time zone"
    #   column :active, "boolean", :default=>false
    #   column :admin, "boolean", :default=>false
    #   column :registered, "boolean"
    #   foreign_key :parent_id, :users, :type=>"uuid", :key=>[:id]
    #   column :invites_count, "integer", :default=>0
    #   column :github, "text"
    #   column :activated_at, "timestamp without time zone"
    #   column :secret, "text"
    #   column :manifesto, "boolean", :default=>false

    #   primary_key [:id]

    #   index [:handle]
    #   index [:iid], :unique=>true
    #   index [:uid], :unique=>true
    # end
  end
end

