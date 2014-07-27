require "globalize"
require "globalize-accessors"
require "globalize-validations/model"
require "globalize-validations/concern"

module Globalize
  module Validations
  end
end

ActiveRecord::Base.extend Globalize::Validations::Model
