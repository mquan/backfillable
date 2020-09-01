# frozen_string_literal: true

module Backfillable
  class Configuration
    attr_accessor :backfills_path, :backfills_table_name, :verbose

    def initialize
      @backfills_path = nil
      @backfills_table_name = nil
      @verbose = true
    end
  end
end