# RocketNavigation

# WORK IN PROGRESS
# (NOT WORKING YET)

This gem is heavily inspired by (and uses some code from) [simple-navigation](https://github.com/codeplant/simple-navigation) but it is NOT a drop-in replacement.

Changes include:

1. Thread safety
2. Supports only Rails, support for sinatra/paradino is removed.
3. Defining navigation via magic eval-loaded config file is not available, use real code.
4. Much simpler and more configurable at the same time.
5. Add highlight by controller \ action

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rocket_navigation'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install rocket_navigation

## Usage

Basic usage is the same and complatible with simple_navigation - but only if you pass menu data as a proc or as items hash (config file not supported).

helper:
```ruby
def navigation(kind = :main)
  proc do |primary|
    primary.item :home, 'Home', root_path do |sub_nav|
      sub_nav.item(:people, 'People', people_path, highlights_on: {controller: :people, action: :index}) do |person|
        person.item :person, @person.try(:name), url_for(@person), highlights_on: /people\/[0-9]+/
        person.item :new_person, 'New Person', new_person_path, highlights_on: /people\/new$/
      end
    end
  end
end
```

view:
```slim
= render_navigation level: 1..2, &navigation(:main)
```

See https://github.com/codeplant/simple-navigation/wiki/Dynamic-Navigation-Items

This gem aims to be a drop-in replacement for this mode, including custom renderer code and api.
Any incomatibility can be reported as a bug.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rs-pro/rocket_navigation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
Parts of code Copyright (c) 2017 codeplant GmbH - used under [MIT License](https://github.com/codeplant/simple-navigation/blob/master/LICENSE)

## Code of Conduct

Everyone interacting in the RocketNavigation project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rs-pro/rocket_navigation/blob/master/CODE_OF_CONDUCT.md).
