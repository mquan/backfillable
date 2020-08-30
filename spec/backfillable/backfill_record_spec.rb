# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Backfillable::BackfillRecord do
  describe '.primary_key' do
    it 'returns version' do
      expect(described_class.primary_key).to eq('version')
    end
  end

  describe '.table_name' do
    it "returns 'data_backfills'" do
      expect(described_class.table_name).to eq('data_backfills')
    end
  end

  describe '.create_table' do
    context "when table doesn't exist" do
      it 'creates table' do
        expect { described_class.create_table }.to change {
          described_class.connection.schema_cache.clear!
          described_class.table_exists?
        }.from(false).to(true)
      end
    end

    context 'when table exists' do
      before { described_class.create_table }

      it 'does not create new table' do
        expect { described_class.create_table }.not_to change {
          described_class.connection.schema_cache.clear!
          described_class.table_exists?
        }

        described_class.connection.schema_cache.clear!
        expect(described_class.table_exists?).to be_truthy
      end
    end
  end

  describe '.drop_table' do
    context 'when table exists' do
      before { described_class.create_table }

      it 'drops the table' do
        expect { described_class.drop_table }.to change {
          described_class.connection.schema_cache.clear!
          described_class.table_exists?
        }.from(true).to(false)
      end
    end

    context 'when table does not exist' do
      it 'does not change' do
        expect { described_class.drop_table }.not_to change {
          described_class.connection.schema_cache.clear!
          described_class.table_exists?
        }

        described_class.connection.schema_cache.clear!
        expect(described_class.table_exists?).to be_falsey
      end
    end
  end

  describe '.all_versions' do
    let!(:backfills) do
      described_class.create_table
      [1, 2].each { |v| described_class.create!(version: v.to_s * 10) }
    end

    it 'returns all record versions' do
      expect(described_class.all_versions).to eq([
        '1111111111',
        '2222222222'
      ])
    end
  end

  describe '#version' do
    let(:backfill) { described_class.create!(version: '123456789') }
    before do
      described_class.create_table

      # This reloads the class and re-initialize the columns as AR attrs.
      described_class.reset_column_information
    end

    it 'returns the version as integer' do
      expect(backfill.version).to eq(123456789)
    end
  end
end
