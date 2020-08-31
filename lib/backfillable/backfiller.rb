# frozen_string_literal: true

require_relative './backfill_record'
require_relative './configuration'

module Backfillable
  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end
  end

  class Backfiller
    BackfillProxy = Struct.new(:name, :version, :filename, :scope) do
      def initialize(name, version, filename, scope)
        super
        @backfill = nil
      end

      def basename
        File.basename(filename)
      end

      delegate :perform, to: :backfill

      private

      def backfill
        @backfill ||= load_backfill
      end

      def load_backfill
        require(File.expand_path(filename))
        name.constantize.new
      end
    end

    BACKFILL_FILENAME_REGEX = /\A([0-9]+)_([_a-z0-9]*)\.?([_a-z0-9]*)?\.rb\z/

    def self.backfills_paths
      Backfillable.config.backfills_paths || ['backfills']
    end

    def self.backfill!
      new.backfill!
    end
    private_class_method :new

    def backfill!
      BackfillRecord.create_table

      pending_backfills.each do |proxy|
        run(proxy)
      end
    end

    private

    def label_for(backfill)
      "#{backfill.version} #{backfill.name}"
    end

    def run(backfill)
      puts "#{label_for(backfill)} backfilling" if Backfillable.config.verbose
      ti = Time.now
      backfill.perform
      record_completed_backfill(backfill.version)
      tf = Time.now
      puts "#{label_for(backfill)} completed #{(tf - ti).round(1)}s" if Backfillable.config.verbose
    end

    def record_completed_backfill(version)
      BackfillRecord.create!(version: version.to_s)
    end

    def backfill_files
      paths = Array(self.class.backfills_paths)
      Dir[*paths.flat_map { |path| "#{path}/**/[0-9]*_*.rb" }]
    end

    def parse_backfill_filename(filename)
      File.basename(filename).scan(BACKFILL_FILENAME_REGEX).first
    end

    def all_backfills
      @all_backfills ||= backfill_files.map do |filename|
        version, name, scope = parse_backfill_filename(filename)
        raise "Invalid backfill filename #{filename}" unless version

        BackfillProxy.new(name.camelize, version.to_i, filename, scope)
      end
    end

    def pending_backfills
      all_backfills.reject { |b| completed_versions.include?(b.version) }
    end

    def completed_versions
      @completed_versions ||= Set.new(BackfillRecord.all_versions.map(&:to_i))
    end
  end
end
