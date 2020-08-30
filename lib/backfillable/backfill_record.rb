# frozen_string_literal: true

# may need to require active_record/base

module Backfillable
  class BackfillRecord < ActiveRecord::Base
    self.data_backfills_table_name = 'data_backfills'

    class << self
      def primary_key
        "version"
      end

      def table_name
        # TODO: support customized backfills name
        data_backfills_table_name
      end

      def create_table
        unless table_exists?
          version_options = connection.internal_string_options_for_primary_key

          connection.create_table(table_name, id: false) do |t|
            t.string :version, **version_options
          end
        end
      end

      def drop_table
        connection.drop_table table_name, if_exists: true
      end

      def all_versions
        order(:version).pluck(:version)
      end
    end

    def version
      super.to_i
    end
  end
end