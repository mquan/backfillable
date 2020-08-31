# frozen_string_literal: true

require 'active_record'

module Backfillable
  class BackfillRecord < ActiveRecord::Base
    class << self
      def primary_key
        "version"
      end

      def table_name
        # TODO: support customized backfills name
        'data_backfills'
      end

      def create_table
        unless table_exists?
          version_options = connection.internal_string_options_for_primary_key

          connection.create_table(table_name, id: false) do |t|
            t.string :version, **version_options
          end

          # Refresh class so that it awares of the new table and column
          connection.schema_cache.clear!
          reset_column_information
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