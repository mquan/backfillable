# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Backfillable::Configuration do
  describe '.new' do
    it 'initializes override values' do
      config = described_class.new
      expect(config.backfills_paths).to be_nil
      expect(config.backfills_table_name).to be_nil
      expect(config.verbose).to be_truthy
    end
  end
end
