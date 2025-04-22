# frozen_string_literal: true

module OneRoster
  class Client
    attr_accessor :app_id, :app_token, :api_url, :token_url, :roster_app,
                  :app_secret, :logger, :vendor_key,
                  :username_source, :oauth_strategy, :staff_username_source, :token_content_type,
                  :sentry_client, :only_provision_current_terms

    attr_reader :authenticated

    def initialize(oauth_strategy = 'oauth')
      @authenticated = false
      @oauth_strategy = oauth_strategy
    end

    def self.configure
      client = new
      yield(client) if block_given?
      client
    end

    %i(students teachers classes).each do |record_type|
      define_method(record_type) do |record_uids = []|
        authenticate

        endpoint = OneRoster.const_get("#{record_type.upcase}_ENDPOINT")

        type = Types.const_get(Dry::Inflector.new.singularize(record_type.to_s.capitalize))

        records = Paginator.fetch(connection, endpoint, :get, type, client: self).force

        return records if record_uids.empty?

        record_uids_set = record_uids.to_set
        records.select { |record| record_uids_set.include?(record.uid) }
      end
    end

    def admins(record_uids = [])
      authenticate

      records = Paginator.fetch(connection, ADMINS_ENDPOINT, :get, Types::Admin, client: self).force

      return records if record_uids.empty?

      record_uids_set = record_uids.to_set
      records.select { |record| record_uids_set.include?(record.uid) }
    end

    def schools
      authenticate

      Paginator.fetch(connection, SCHOOLS_ENDPOINT,
                      :get, Types::School, client: self).force
    end

    def classrooms(course_codes = [])
      authenticate

      oneroster_classes = classes
      fetched_schools = schools

      terms_hash = terms.each_with_object({}) { |term, terms| terms[term.uid] = term }

      courses = courses(course_codes, oneroster_classes)

      oneroster_classes.each_with_object([]) do |oneroster_class, oneroster_classes|
        course = courses.find { |course| course.uid == oneroster_class.course_uid }
        next unless course

        term = terms_hash[oneroster_class.term_id&.first]
        school = fetched_schools.find { |school| school.uid == oneroster_class.school_uid }

        oneroster_classes << Types::Classroom.new(
          'id' => oneroster_class.uid,
          'name' => oneroster_class.title,
          'course_number' => course.course_code,
          'period' => oneroster_class.period,
          'grades' => oneroster_class.grades,
          'subjects' => oneroster_class.subjects,
          'term_name' => term&.name,
          'term_start_date' => term&.start_date,
          'term_end_date' => term&.end_date,
          'term_id' => oneroster_class.term_id,
          'school_name' => school&.name,
          'school_uid' => school&.uid
        )
      end
    end

    def terms
      authenticate

      endpoint = OneRoster::ACADEMIC_SESSIONS_ENDPOINT

      type = Types::Term

      Paginator.fetch(connection, endpoint, :get, type, client: self).force
    end

    def courses(course_codes = [], oneroster_classes = classes)
      authenticate

      class_course_numbers = oneroster_classes.map(&:course_uid)

      courses = Paginator.fetch(
        connection,
        COURSES_ENDPOINT,
        :get,
        Types::Course,
        client: self
      ).force

      parse_courses(courses, course_codes, class_course_numbers)
    end

    def enrollments(classroom_uids = [])
      authenticate

      enrollments = parse_enrollments(classroom_uids)

      p "Found #{enrollments.values.flatten.length} enrollments."

      enrollments
    end

    def authenticate
      return if authenticated?

      if oauth_strategy == 'oauth2'
        response = token

        fail ConnectionError, response.raw_body unless response.success?

        set_auth_headers(response.raw_body, response.headers['set-cookie'])
      else
        response = connection.execute(TEACHERS_ENDPOINT, :get, limit: 1)

        fail ConnectionError, response.raw_body unless response.success?
      end

      @authenticated = true
    end

    def authenticated?
      @authenticated
    end

    def connection
      @connection ||= Connection.new(self, oauth_strategy)
    end

    def token
      url = token_url || "#{api_url}/token"

      credential_params = { grant_type: 'client_credentials',
                            scope: 'https://purl.imsglobal.org/spec/or/v1p1/scope/roster-core.readonly' }

      if roster_app == 'infinite_campus'
        connection.execute(url, :post, credential_params, nil, token_content_type)
      elsif roster_app == 'synergy'
        connection.execute(url, :post, nil, credential_params, token_content_type)
      else
        connection.execute(url, :post)
      end
    end

    def set_auth_headers(token, cookie)
      connection.set_auth_headers(token['access_token'], cookie)
    end

    private

    def parse_enrollments(classroom_uids = [])
      enrollments = Paginator.fetch(
        connection,
        ENROLLMENTS_ENDPOINT,
        :get,
        Types::Enrollment,
        client: self
      ).force

      enrollments.each_with_object(teacher: [], student: []) do |enrollment, enrollments|
        next if classroom_uids.any? && !classroom_uids.include?(enrollment.classroom_uid)

        enrollments[enrollment.role.to_sym] << enrollment if enrollment.valid?
      end
    end

    def parse_courses(courses, course_codes, course_numbers)
      courses.select do |course|
        in_course_numbers = course_numbers.include?(course.uid)

        if course_codes.any?
          course_codes.include?(course.course_code) && in_course_numbers
        else
          in_course_numbers
        end
      end
    end
  end
end
