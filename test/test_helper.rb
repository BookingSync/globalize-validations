require 'i18n'
I18n.available_locales = [:en, :es, :fr]
I18n.enforce_available_locales = true

require 'minitest/autorun'
require 'active_support'
require 'active_support/test_case'
require 'logger'

require 'globalize-validations'

test_dir = File.dirname(__FILE__)

I18n::Backend::Simple.include(I18n::Backend::Fallbacks)

ActiveRecord::Base.logger = Logger.new(File.join(test_dir, "debug.log"))
ActiveRecord::Base.establish_connection(
  adapter: "sqlite3",
  database: ":memory:"
)
ActiveRecord::Schema.define do
  create_table "pages", :force => true do |t|
    t.integer  "position"
  end

  create_table "page_translations", :force => true do |t|
    t.references :page
    t.string "title"
    t.text "body"
    t.string "locale"
  end
end
