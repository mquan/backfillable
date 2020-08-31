# frozen_string_literal: true

module Backfillable
  class Backfill
    def perform
      raise NotImplementedError
    end
  end
end
