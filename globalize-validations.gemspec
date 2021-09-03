$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "globalize-validations/version"

Gem::Specification.new do |s|
  s.name        = "globalize-validations"
  s.version     = Globalize::Validations::VERSION
  s.authors     = ["Sebastien Grosjean", "Braulio Martinez LM", "Adrian Mugnolo"]
  s.email       = ["dev@bookingsync.com", "brauliomartinezlm@gmail.com", "adrian@mugnolo.com"]
  s.homepage    = "https://github.com/BookingSync/globalize-validations"
  s.summary     = "Validates translated attributes accessed with globalized accessors"
  s.description = "Validates translated attributes accessed with globalized accessors"
  s.license     = "MIT"

  s.files = Dir["{app,config,db,lib}/**/*", "MIT-LICENSE", "Rakefile", "README.md"]
  s.test_files = Dir["span/**/*"]

  s.add_dependency "globalize"
  s.add_dependency "globalize-accessors"
  s.add_dependency "activerecord"

  s.add_development_dependency "rake"
  s.add_development_dependency "sqlite3"
  s.add_development_dependency "minitest"
end
