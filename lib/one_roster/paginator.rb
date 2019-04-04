# frozen_string_literal: true

module OneRoster
  PAGE_LIMIT = 5_000

  class Paginator
    def initialize(connection, path, method, type, offset = 0, limit = PAGE_LIMIT)
      @connection = connection
      @path       = path
      @method     = method
      @type       = type
      @offset     = offset
      @limit      = limit
      @next_path  = nil
    end

    def fetch
      Enumerator.new do |yielder|
        loop do
          response = request(@path, @offset)
          body = response.body

          fail "Failed to fetch #{path}" unless response.success?

          if body.any?
            body.each { |item| yielder << @type.new(item) unless item['status'] == 'tobedeleted' }
          end

          fail StopIteration if body.length < @limit

          @offset = next_offset
        end
      end.lazy
    end

    def self.fetch(*params)
      new(*params).fetch
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

