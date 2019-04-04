# frozen_string_literal: true

require 'ostruct'

module OneRoster
  class MockFaradayRequest
    attr_accessor :options, :headers, :body, :response

    def initialize
      @options = OpenStruct.new
      @headers = OpenStruct.new
      @body    = ''
      @path    = nil
      @params  = nil
    end

    def url(path, params)
      @path   = path
      @params = params
    end
  end


  class MockFaradayConnection
    def initialize(response)
      @response = response
    end

    def get
      yield(MockFaradayRequest.new)
      @response
    end
  end
end
