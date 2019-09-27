module OneRoster
  class Response
    attr_reader :status, :raw_body, :headers

    attr_accessor :body

    def initialize(faraday_response)
      @status = faraday_response.status
      @raw_body = faraday_response.body
      @type = resource_type(faraday_response)

      return unless faraday_response.body

      @body = faraday_response.body[@type]

      return unless faraday_response.headers

      @headers = faraday_response.headers
    end

    def success?
      @status == 200
    end

    private

    def resource_type(faraday_response)
      RESPONSE_TYPE_MAP[faraday_response.env.url.path.split('/').last]
    end
  end
end
