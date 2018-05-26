# RocketNavigation

[![Build Status](https://travis-ci.org/rs-pro/rocket_navigation.svg?branch=master)](https://travis-ci.org/rs-pro/rocket_navigation)
[![Gem Version](https://badge.fury.io/rb/rocket_navigation.svg)](https://badge.fury.io/rb/rocket_navigation)
[![Maintainability](https://api.codeclimate.com/v1/badges/13260d4bf2e5969a12c6/maintainability)](https://codeclimate.com/github/rs-pro/rocket_navigation/maintainability)
[![Test Coverage](https://api.codeclimate.com/v1/badges/13260d4bf2e5969a12c6/test_coverage)](https://codeclimate.com/github/rs-pro/rocket_navigation/test_coverage)

# Status

Currently beta quality, but we already use it in production for some projects.

Lots of tests (which were copied and adapted from SimpleNavigation) are failing, but the gem itself works and is somewhat tested in real world projects as a replacement for SimpleNavigation.

But anyway use at your own risk.

# About

This gem is heavily inspired by (and uses some code from) [simple-navigation](https://github.com/codeplant/simple-navigation) but it is NOT a drop-in replacement.

Changes include:

1. Simple with no dark magic involved
2. Thread safe with no mutexes. (simple_navigation's render_navigation can render incomplete navs and not render any items at all under multithread load due to app-global config, which is used internally even if proc or items passed)
3. Supports only Rails, support for sinatra/paradino is removed.
4. Defining navigation via magic eval-loaded config file is not available, use real code.
5. Much simpler and more configurable at the same time.
6. Add many additional highlight options from [active_link_to](https://github.com/comfy/active_link_to) gem
7. Add ability to set CSS classes and container DOM attributes on render
8. ID autogeneration is removed
9. Rewritten to use and allow helpers in renderers and to use ActiveSupport::SafeBuffer everywhere in renderers
10. All css classes are managed in renderers and can be easily overriden from them
11. Added [breadcrumbs_on_rails](https://github.com/weppos/breadcrumbs_on_rails) integration
12. expand_all defaults to true, as pretty much all menus are js-based now.
13. Includes bootstrap 4 renderer

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
      sub_nav.item(:people, 'People', people_path, highlights_on: [:people, :show]) do |person|
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

## More docs

Basic menu usage is the same as simple-navigation

See https://github.com/codeplant/simple-navigation/wiki/Dynamic-Navigation-Items

This gem aims to be a drop-in replacement for this mode, including custom renderer code and api.
Any incomatibility can be reported as a bug.

Most renderers should be compatible out of the box, or require minimal changes due to ActiveSupport::SafeBuffer usage instead of .html_safe.

## Setting HTML attributes

on render:

```ruby
# helper
def menu_options
  {
    container_html: {class: "nav"},
    item_html: {
      class: 'nav nav-item'
    },
    link_html: {
      class: %w(link nav-link),
      rel: "nofollow",
    },
    selected_class: {
      leaf: "selected-leaf",
      item: "selected-li",
      link: "selected-a"
    }
  }
end
```

view:
```
= render_navigation menu_options, &navigation(:main)
= render_navigation no_default_classes: true, &navigation(:main)
= render_navigation renderer: :breadcrumbs, no_default_classes: true, prefix: "You are here: ", static_leaf: true, join_with: " &rarr; ".html_safe, &extra_nav
```

bootstrap example:
```
= render_navigation container_html: {class: "nav navbar-nav"}, renderer: :bootstrap, &navigation(:main)
```

Same options could be defined on a container when defining menu:
```ruby
def navigation(kind = :main)
  proc do |primary|
    primary.container_html = {class: "nav"}
    primary.item_html = {class: 'nav-item'}
    primary.link_html = {class: 'nav-link'}
    primary.selected_class = {branch: "active-branch", item: "active", link: "active"}
    primary.item :home, 'Home', root_path, item_html: {class: "other"}, link_html: {class: "other"}
    primary.item :two, 'Two', root_path, item_html: {class: "more two"}, link_html: {class: "two", method: :post}
  end
end
helper_method :navigation
```


HTML options priority - item, renderer, default

## BreadcrumbsOnRails integration

Just render with a breadcrumbs_on_rails renderer.
Returns nothing, calls add_breadcrumb instead.
Should be called before ```= render_breadcrumbs```, i.e. in controller

```
render_navigation renderer: :breadcrumbs_on_rails, &navigation(:main)
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/rs-pro/rocket_navigation. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

Parts of code Copyright (c) 2017 codeplant GmbH - [MIT License](https://github.com/codeplant/simple-navigation/blob/master/LICENSE)

Uses code from [active_link_to](https://github.com/comfy/active_link_to) - Copyright (c) 2009-17 Oleg Khabarov - [MIT License](https://github.com/comfy/active_link_to/blob/master/LICENSE)

## Code of Conduct

Everyone interacting in the RocketNavigation project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/rs-pro/rocket_navigation/blob/master/CODE_OF_CONDUCT.md).
