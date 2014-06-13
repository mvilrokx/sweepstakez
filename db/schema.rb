Sequel.migration do
  change do
    create_table(:countries, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :country_code, :text=>true, :null=>false
      String :country_name, :text=>true
      Integer :iso_numeric, :null=>false
      String :iso_alpha3, :text=>true, :null=>false
      String :fips_code, :text=>true
      String :continent, :text=>true, :null=>false
      String :continent_name, :text=>true
      String :capital, :text=>true
      Float :area_in_sq_km
      Integer :population
      String :currency_code, :text=>true, :null=>false
      String :languages
      Integer :geoname_id
      Float :west
      Float :north
      Float :east
      Float :south
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:country_code], :unique=>true
      index [:iid], :unique=>true
      index [:iso_alpha3], :unique=>true
      index [:iso_numeric], :unique=>true
    end
    
    create_table(:schema_info) do
      Integer :version, :default=>0, :null=>false
    end
    
    create_table(:tenants, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :name, :text=>true
      String :subdomain, :text=>true
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:iid], :unique=>true
      index [:name], :unique=>true
      index [:subdomain], :unique=>true
    end
    
    create_table(:tournaments, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :name, :text=>true
      String :description, :text=>true
      DateTime :starts_at
      DateTime :ends_at
      String :host_countries
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:iid], :unique=>true
      index [:name], :unique=>true
    end
    
    create_table(:groups, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :name, :text=>true
      foreign_key :tournament_id, :tournaments, :type=>String, :key=>[:id], :on_delete=>:cascade
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:iid], :unique=>true
      index [:tournament_id]
    end
    
    create_table(:users, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :uid, :text=>true
      String :provider, :text=>true
      String :handle, :text=>true
      String :about, :text=>true
      String :email, :text=>true
      String :url, :text=>true
      String :twitter, :text=>true
      Integer :karma, :default=>0
      String :name, :text=>true
      String :auth
      DateTime :created_at
      DateTime :updated_at
      TrueClass :admin, :default=>false
      TrueClass :registered
      foreign_key :tenant_id, :tenants, :type=>String, :key=>[:id], :on_delete=>:cascade
      Integer :invites_count, :default=>0
      String :github, :text=>true
      String :secret, :text=>true
      TrueClass :manifesto, :default=>false
      
      primary_key [:id]
      
      index [:handle]
      index [:iid], :unique=>true
      index [:uid], :unique=>true
    end
    
    create_table(:teams, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      String :name, :text=>true
      foreign_key :user_id, :users, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :tournament_id, :tournaments, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :tenant_id, :tenants, :type=>String, :key=>[:id], :on_delete=>:cascade
      TrueClass :paid, :default=>false
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:iid], :unique=>true
    end
    
    create_table(:tournament_participants, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      foreign_key :group_id, :groups, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :country_id, :countries, :type=>String, :key=>[:id], :on_delete=>:cascade
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:group_id, :country_id], :unique=>true
      index [:iid], :unique=>true
    end
    
    create_table(:fixtures, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      foreign_key :home_tournament_participant_id, :tournament_participants, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :away_tournament_participant_id, :tournament_participants, :type=>String, :key=>[:id], :on_delete=>:cascade
      DateTime :kickoff
      String :venue, :text=>true
      String :result
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:home_tournament_participant_id, :away_tournament_participant_id], :name=>:fixtures_home_tournament_participant_id_away_tournament_partici, :unique=>true
      index [:iid], :unique=>true
    end
    
    create_table(:picks, :ignore_index_errors=>true) do
      String :id, :null=>false
      Integer :iid, :null=>false
      foreign_key :team_id, :teams, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :tournament_participant_id, :tournament_participants, :type=>String, :key=>[:id], :on_delete=>:cascade
      foreign_key :tenant_id, :tenants, :type=>String, :key=>[:id], :on_delete=>:cascade
      Integer :position, :null=>false
      DateTime :created_at
      DateTime :updated_at
      
      primary_key [:id]
      
      index [:iid], :unique=>true
      index [:team_id, :tournament_participant_id], :unique=>true
    end
  end
end
