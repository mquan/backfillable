**backfillable** is a library that helps you manage backfills in your rails app

## Why do you need this?

Over the course of developing your rails app, you may have to carry out changes that render your existing data invalid or unusable. A few of these examples are:

- **Add a null constraint to a db column** - the migration will be blocked until you update the column in existing records to satisfy the new constraint.
- **Add a new validation** - existing records may become invalid and cause error when they are subsequently updated.
- **Add new seed data** - features may not work properly if the new seed data isn't available.

The solution is to backfill the data to prep for upcoming changes in both development and production environments. In a team, you'd also need to communicate to everyone about running your custom backfill code in their development environments. This often results in friction and confusion when team members missed these ephemeral PSAs.

## Solution

**backfillable** solves this problem by emulating how rails manages db migrations. The three core ideas are:

1. **Backfills should be decoupled from migrations** - teams often resort to adding the backfill code as part of the migrations. However, backfill code tend to reference application code, which can easily become outdated/obsolete and cause error when running migrations. In the last example above, we don't even have a migration to latch on to run the backfill.

2. **Backfills should be tracked and run similar to how rails migration works** - each backfill should be run and run only once. Developers do not need to be told which ruby code or rake task to run in their development environment, just that they need to be reminded to run a generic rake task (`rake db:backfill`) when there are outstanding backfills

3. **Backfills are not permanent** - unlike db migrations, backfills should be cleaned up once everyone has run them or when they are no longer relevant.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'backfillable'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install backfillable

## Usage

Create a new backfill

    $ rails generate backfill foo_bar_backfill

This creates a new ruby file in the specified backfills folder (`/backfills`):

```ruby
class FooBarBackfill < Backfillable::Backfill
  def perform
    # Your backfill code goes here
  end
end
```

Run the backfill

    $ rake db:backfill

## Best practice

Sometimes there are dependencies between backfills and db migrations. We want to write backfills such that they are not dependent on order of migrations. Consider the following scenario:

1. Create table `foos`
2. Add null constraint to column `bar` in table `foos`

Your backfill code to prep for step 2 may look like

```ruby
class UpdateBarBackfill < Backfillable::Backfill
  def perform
    Foo.where(bar: nil).update_all(bar: false)
  end
end
```

However, if a developer has not run create table `foos` migration then the backfill will fail because of missing table `foos`.

The right solution in this case is simply to skip the backfill because there's no invalid records in the developer's db, though we still want to mark the backfill complete. We can tweak the code to check that the table exists to achieve it:

```ruby
def perform
  return unless Foo.table_exists?
  Foo.where(bar: nil).update_all(bar: false)
end
```
## Configuration

```ruby
Backfillable.configure do |config|
  config.backfills_paths = ['backfills']
  config.backfills_table_name = 'data_backfills'
  config.verbose = true
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/backfillable.


## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
