# frozen_string_literal: true

module OneRoster
  module Types
    class Term < Base
      attr_reader :uid,
                  :name,
                  :start_date,
                  :end_date

      def initialize(attributes = {}, *)
        @uid        = attributes['sourcedId']
        @name       = attributes['title']
        @start_date = attributes['startDate']
        @end_date   = attributes['endDate']
      end
    end
  end
end
