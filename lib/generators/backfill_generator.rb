require 'rails/generators/named_base'
require 'backfillable/backfiller'

module Rails
  module Generators
    class BackfillGenerator < Rails::Generators::NamedBase
      source_root File.expand_path('templates', __dir__)
      desc "This generator creates a backfill file"

      def create_backfill_file
        template 'backfill.rb', File.join(Backfiller.backfills_paths.first, "#{file_name}_backfill.rb")
      end
    end
  end
end
