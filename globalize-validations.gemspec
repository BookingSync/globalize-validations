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

  s.add_dependency "globalize", ">= 3"
  s.add_dependency "globalize-accessors", "~> 0.1"

  s.add_development_dependency "bundler", "~> 1.3"
  s.add_development_dependency "rake", "~> 0.9"
  s.add_development_dependency "sqlite3", "~> 1.3"
  s.add_development_dependency "minitest", "~> 4.2"
end
