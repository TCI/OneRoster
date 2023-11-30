# frozen_string_literal: true

module OneRoster
  PAGE_LIMIT = 5_000

  class Paginator
    def initialize(connection, path, method, type, offset = 0, limit = PAGE_LIMIT, client: nil)
      @connection = connection
      @path       = path
      @method     = method
      @type       = type
      @offset     = offset
      @limit      = limit
      @client     = client
    end

    def fetch
      Enumerator.new do |yielder|
        loop do
          response = request(@path, @offset)
          body = response.body

          fail "Failed to fetch #{@path}" unless response.success?
          fail StopIteration if body.empty?

          if body.any?
            body.each do |item|
              yielder << @type.new(item, client: @client) unless item['status'] == 'tobedeleted'
            end
          end

          @offset = next_offset
        end
      end.lazy
    end

    def self.fetch(*params, **kwargs)
      new(*params, **kwargs).fetch
    end

    private

    def next_offset
      @offset + @limit
    end

    def request(path, offset)
      @connection.execute(path, @method, limit: @limit, offset: offset)
    end
  end
end

