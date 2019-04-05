# OneRoster

This is a simple Ruby API wrapper for OneRoster.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'one_roster'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install one_roster

## Usage

### Configuration
The gem can be initialized as follows:

```ruby
client = OneRoster::Client.configure do |config|
  config.app_id     = 'app_id for district'
  config.app_secret = 'app_secret for district'
  config.api_url    = 'api_url for district'
end
```

### Requests
This gem supports requesting:
  - Students 
  - Teachers
  - Classes
  - Classrooms 
  - Courses 
  - Enrollments
  
#### Students
- Request all students: 
  ```ruby
    client.students
  ```
- Request a subset of students filtered by their `sourcedId`:
  ```ruby
    client.students([student_1['sourcedId']], student_2['sourcedId'], …])
  ``` 
#### Teachers
- Request all students: 
  ```ruby
  client.teachers
  ```
- Request a subset of teachers filtered by their `sourcedId`:
  ```ruby
  client.teachers([teacher_1['sourcedId']], teacher_2['sourcedId'], …])
  ``` 
#### Classes
- Request all classes: 
  ```ruby
  client.classes
  ```
- Request a subset of classes filtered by their `sourcedId`:
  ```ruby
  client.classes([class_1['sourcedId']], class_2['sourcedId'], …])
  ``` 
#### Classrooms
- Request all classrooms: 
  ```ruby
  client.classrooms
  ```
- Request a subset of active classrooms whose UIDs are found in OneRoster's classes, filtered by their course's `sourcedId`:
  ```ruby
  client.classes([enrollment_1['course']['sourcedId'], enrollment_2['course']['sourcedId'], …])
  ``` 
#### Courses
- Request all courses: 
  ```ruby
  client.courses
  ```
- Request a subset of active courses whose UIDs are found in OneRoster's classes, filtered by their `sourcedId`:
  ```ruby
  client.classes([course_1['sourcedId'], course_2['sourcedId'], …])
  ``` 
#### Enrollments
- Request all enrollments
  ```ruby
    client.enrollments
  ```
- Request a subset of active enrollments filtered by their class's `sourcedID`: 
  ```ruby
  client.enrollments([class_1['sourcedId'], class_2['sourcedId']])
  ```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `bin/rspec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/tci/oneroster.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
