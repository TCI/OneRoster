# frozen_string_literal: true

module OneRoster
  module Types
    class School
      attr_reader :uid, :name, :number

      def initialize(attributes = {}, *)
        @uid      = attributes['sourcedId']
        @name     = attributes['name']
        @number   = attributes['identifier']
        @provider = 'oneroster'
      end
    end
  end
end
