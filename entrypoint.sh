#!/usr/bin/env bash
set -e

APP_DIR=/app

generate_app() {
  echo ">> Generating Rails API app (first run)..."
  rails new . --api -d postgresql --skip-javascript --skip-test
  # Inject required gems
  echo "gem 'rspec-rails', group: [:development, :test]" >> Gemfile
  echo "gem 'rack-cors'" >> Gemfile
  bundle install

  # Configure database.yml to use env DATABASE_URL if present
  cat > config/database.yml <<'YAML'
default: &default
  url: <%= ENV['DATABASE_URL'] %>
  pool: 5
  timeout: 5000

development:
  <<: *default

test:
  <<: *default
  url: <%= ENV['DATABASE_TEST_URL'] || ENV['DATABASE_URL'] %>

production:
  <<: *default
YAML

  # CORS
  cat > config/initializers/cors.rb <<'RUBY'
Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '*', headers: :any, methods: [:get, :post, :put, :patch, :delete, :options, :head]
  end
end
RUBY

  # RSpec install (optional)
  rails g rspec:install || true

  # Create models and controllers
  rails g model Patient first_name:string last_name:string middle_name:string birthday:date gender:string height:integer weight:integer
  rails g model Doctor first_name:string last_name:string middle_name:string
  rails g model BmrRecord patient:references formula:string value:integer
  rails g model DoctorPatient doctor:references patient:references

  # Add unique index migration for patients
  cat > db/migrate/99999999999999_add_unique_index_to_patients.rb <<'RUBY'
class AddUniqueIndexToPatients < ActiveRecord::Migration[7.1]
  def change
    add_index :patients, [:first_name, :last_name, :middle_name, :birthday], unique: true, name: 'idx_patients_unique_identity'
  end
end
RUBY

  # Copy our app code overrides
  cp -R /bootstrap/app/* app/
  cp -R /bootstrap/config/* config/ || true

  # Routes
  cp /bootstrap/config/routes.rb config/routes.rb

  # Run migrations
  rails db:create db:migrate

  # Seed sample data
  rails runner /bootstrap/scripts/seed.rb || true
}

cd $APP_DIR

if [ ! -f "$APP_DIR/Gemfile" ]; then
  generate_app
else
  echo ">> Rails app already present. Running migrations..."
  bundle install || true
  rails db:migrate || true
fi

echo ">> Starting Rails server on 0.0.0.0:3000"
exec rails s -b 0.0.0.0 -p 3000
