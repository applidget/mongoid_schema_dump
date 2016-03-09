# Mongoid Schema Dump

This gem allows you to dump your Mongoid schema based on a top level object. If you have an `Organization` model or equivalent, this tool can help you get the shortest path (by following `belongs_to` relationships) from any other object from your data model to your `Organization` model. 

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'mongoid_schema_dump'
```
Then run `bundle install`

Or install it yourself as:

    $ gem install mongoid_schema_dump

## Usage in Rails

You can install a rake task in your app allowing you to dump your schema. This rake task will have to be customized in order to take into account what is specific about your data model, in particular the reference class, which is Organization in the default generated rake task :

    $ bundle exec rails generate mongoid_schema_dump:task


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/applidget/mongoid_schema_dump. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

