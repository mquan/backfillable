require 'backfillable'

namespace :db do
  desc "Run all db backfills"
  task :backfill do
    Backfillable::Backfiller.backfill!
  end

  Rake::Task['db'].enhance([:backfill]) if Backfillable.run_before_migration
end
