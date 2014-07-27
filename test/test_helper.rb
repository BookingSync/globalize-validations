require 'i18n'
I18n.available_locales = [:en, :es, :fr]
I18n.enforce_available_locales = true

require 'minitest/autorun'
require 'active_support'
require 'active_support/test_case'
require 'logger'

require 'globalize-validations'

test_dir = File.dirname(__FILE__)

ActiveRecord::Base.logger = Logger.new(File.join(test_dir, "debug.log"))
ActiveRecord::Base.configurations = YAML::load(IO.read(File.join(test_dir, 'db', 'database.yml')))
ActiveRecord::Base.establish_connection("sqlite3mem")
ActiveRecord::Migration.verbose = false
load(File.join(test_dir, "db", "schema.rb"))
