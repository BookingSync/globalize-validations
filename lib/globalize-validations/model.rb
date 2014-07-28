module Globalize
  module Validations
    module Model
      # Enables validations for all available locales
      #
      # @param options [Hash] Configuration options for globalize-validations.
      #   They are inherited by subclasses, but can be overwritten in the subclass.
      # @option options [Symbol] locales: locales against which the object will be validated,
      #   default is the Model's globalize_locales.
      def globalize_validations(options = {})
        options.reverse_merge!(locales: self.globalize_locales)
        class_attribute :globalize_validations_locales

        self.globalize_validations_locales = options[:locales]

        include Globalize::Validations::Concern
      end
    end
  end
end
