# frozen_string_literal: true

class BogusName < Backfillable::Backfill do
  def perform
    raise 'This should not be run'
  end
end
