[![Code Climate](https://codeclimate.com/github/BookingSync/globalize-validations.png)](https://codeclimate.com/github/BookingSync/globalize-validations)
[![CI](https://github.com/BookingSync/globalize-validations/actions/workflows/ci.yml/badge.svg)](https://github.com/BookingSync/globalize-validations/actions/workflows/ci.yml)

# Globalize-Validations

Globalize Validations validates your translated attributes for each given locales.
The errors are added to the globalize attributes accessor names (example `title_en`).

`globalize-validations` is compatible with Rails 5.2, Rails 6.x and Rails 7.0.x.

## Documentation

[API documentation is available at rdoc.info](http://rdoc.info/github/BookingSync/globalize-validations/master/frames).

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'globalize-validations'
```

And then execute:

```
$ bundle
```

## Usage

Default

```ruby
class Page < ActiveRecord::Base
  translates :title, :body
  globalize_accessors locales: [:en, :es, :fr, :pl], attributes: [:title]
  globalize_validations # Will use Model.globalize_locales by default

  # Add all your validations before
  validate :validates_globalized_attributes
end
```

With custom locales

```ruby
class Page < ActiveRecord::Base
  translates :title, :body
  globalize_accessors locales: [:en, :es, :fr, :pl], attributes: [:title]
  globalize_validations locales: [:en, :es] # Validates only `:en` and `:es` locales

  # Add all your validations before
  validate :validates_globalized_attributes
end
```

With custom locales as Proc

```ruby
class Page < ActiveRecord::Base
  translates :title, :body
  globalize_accessors locales: [:en, :es, :fr, :pl], attributes: [:title]
  globalize_validations locales: Proc.new { |page| page.available_locales }

  # Add all your validations before
  validate :validates_globalized_attributes
end
```

## Licence

Copyright (c) 2014 BookingSync released under the MIT license
