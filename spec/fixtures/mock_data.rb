# frozen_string_literal: true

module MockData
  class << self
    def reset
      @data = []
    end

    def data
      @data ||= []
    end
  end
end