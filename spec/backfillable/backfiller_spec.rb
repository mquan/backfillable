# frozen_string_literal: true

require 'spec_helper'
require 'fixtures/mock_data'

RSpec.describe Backfillable::Backfiller do
  describe '.backfills_path' do
    subject { described_class.backfills_path }

    context 'when path is not configured' do
      it 'returns backfills path' do
        is_expected.to eq('backfills')
      end
    end

    context 'when path is configured' do
      let(:path) { 'dev_backfills' }
      before { Backfillable.config.backfills_path = path }
      after {  Backfillable.config.backfills_path = nil }

      it 'returns configured path' do
        is_expected.to eq(path)
      end
    end
  end

  describe '.backfill!' do
    subject { described_class.backfill! }

    let(:version_1) { '1598836899' }
    let(:version_2) { '1598836943' }

    before do
      Backfillable::BackfillRecord.create_table
      MockData.reset
      Backfillable.config.backfills_path = 'spec/fixtures/test_backfills'
    end

    after do
      Backfillable.config.backfills_path = nil
    end

    context 'when all backfills have not been completed' do
      it 'backfills pending backfills' do
        expect { subject }.to change(Backfillable::BackfillRecord, :count).by(2)
        expect(Backfillable::BackfillRecord.all_versions).to eq([
          version_1,
          version_2
        ])
        expect(MockData.data).to eq(['first', 'second'])
      end
    end

    context 'when a backfill was completed' do
      before { Backfillable::BackfillRecord.create!(version: version_1) }

      it 'runs the other backfills' do
        expect { subject }.to change(Backfillable::BackfillRecord, :count).by(1)
        expect(Backfillable::BackfillRecord.all_versions).to eq([
          version_1,
          version_2
        ])
        expect(MockData.data).to eq(['second'])
      end
    end

    context 'when all backfills were completed' do
      before do
        [version_1, version_2].each do |version|
          Backfillable::BackfillRecord.create!(version: version)
        end
      end

      it 'does not run any backfills' do
        expect { subject }.not_to change(Backfillable::BackfillRecord, :count)
        expect(Backfillable::BackfillRecord.all_versions).to eq([
          version_1,
          version_2
        ])
        expect(MockData.data).to eq([])
      end
    end
  end
end
