# frozen_string_literal: true

require 'backfillable/backfill'

class <%= class_name %>Backfill < Backfillable::Backfill
  def perform
    # Your backfill code goes here
  end
end
