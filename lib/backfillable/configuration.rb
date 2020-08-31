# frozen_string_literal: true

module Backfillable
  class Configuration
    attr_accessor :backfills_paths, :backfills_table_name, :verbose

    def initialize
      @backfills_paths = nil
      @backfills_table_name = nil
      @verbose = true
    end
  end
end