#!/usr/bin/env rake
require 'dotenv/tasks'

task :app => :dotenv do
  require './app'
end

namespace :db do
  desc 'Run DB migrations'
  task :migrate => :app do
   require 'sequel/extensions/migration'

   Sequel::Migrator.apply(Sweepstakes::App.database, 'db/migrations')
  end

  desc 'Rollback migration'
  task :rollback => :app do
    require 'sequel/extensions/migration'

    database = Sweepstakes::App.database
    version  = (row = database[:schema_info].first) ? row[:version] : nil
    Sequel::Migrator.apply(database, 'db/migrations', version - 1)
  end

  desc 'Drop the database'
  task :drop => :app do
    database = Sweepstakes::App.database

    database.tables.each do |table|
      database.run("DROP TABLE #{table} CASCADE")
    end
  end

  desc 'Dump the database schema'
  task :dump => :app do
    database = Sweepstakes::App.database

    `sequel -d #{database.url} > db/schema.rb`
    `pg_dump --schema-only #{database.url} > db/schema.sql`
  end

  desc 'Load the seed data from db/seeds.rb'
  task :seed do
    seed_file = "./db/seeds.rb"
    puts "Seeding database from: #{seed_file}"
    load(seed_file) if File.exist?(seed_file)
  end

end

Dir[File.dirname(__FILE__) + "/lib/tasks/*.rb"].sort.each do |path|
  require path
end