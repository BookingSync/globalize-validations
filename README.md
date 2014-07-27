[![Code Climate](https://codeclimate.com/github/BookingSync/globalize-validations.png)](https://codeclimate.com/github/BookingSync/globalize-validations)
[![Build Status](https://travis-ci.org/BookingSync/globalize-validations.png?branch=master)](https://travis-ci.org/BookingSync/globalize-validations)

# Globalize-Validations

Globalize Validations validates your translated attributes for each given locales.
The errors are added to the globalize attributes accessor names (example `title_en`).

`globalize-validations` is compatible with Rails 3.x, Rails 4.0.x and Rails 4.1.x.

## Requirements

Globalize `>= 3.0.0`, Globalize-Accessors `>= 0.1.3` and Ruby `>= 1.9.3`.

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
