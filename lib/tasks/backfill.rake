require 'backfillable'

namespace :db do
  desc "Run all db backfills"
  task :backfill do
    Backfillable::Backfiller.backfill!
  end
end
