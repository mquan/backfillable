# frozen_string_literal: true

require 'backfillable'
require 'fixtures/mock_data'

class FirstTestBackfill < Backfillable::Backfill
  def perform
    MockData.data.push('first')
  end
end