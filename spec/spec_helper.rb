require "bundler/setup"
require "backfillable"
require "backfillable/backfill_record"

require "rails"
require 'active_record'
ActiveRecord::Base.establish_connection(adapter: "sqlite3", database: ":memory:")

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  # Disable RSpec exposing methods globally on `Module` and `main`
  config.disable_monkey_patching!

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end

  config.before(:each) do
    Backfillable.config.verbose = false
  end

  config.after(:each) do
    Backfillable::BackfillRecord.drop_table
    Backfillable::BackfillRecord.connection.schema_cache.clear!
  end
end
