# frozen_string_literal: true

require 'backfillable'
require 'fixtures/mock_data'

class SecondTestBackfill < Backfillable::Backfill
  def perform
    MockData.data.push('second')
  end
end