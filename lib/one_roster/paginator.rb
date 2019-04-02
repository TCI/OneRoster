# frozen_string_literal: true

module OneRoster
  PAGE_LIMIT = 5_000

  class Paginator
    def initialize(connection, path, method, type, offset = 0)
      @connection = connection
      @path       = path
      @method     = method
      @type       = type
      @offset     = offset
      @next_path  = nil
    end

    def fetch
      Enumerator.new do |yielder|
        loop do
          response = request(@path, @offset)
          body = response.body

          raise "Failed to fetch #{path}" unless response.success?

          body.each { |item| yielder << @type.new(item) } if body.any?

          raise StopIteration if body.length < PAGE_LIMIT

          @offset = next_offset
        end
      end.lazy
    end

    def self.fetch(*params)
      new(*params).fetch
    end

    private

    def next_offset
      @offset + PAGE_LIMIT
    end

    def request(path = @path, offset)
      @connection.execute(path, @method, limit: PAGE_LIMIT, offset: offset)
    end
  end
end

