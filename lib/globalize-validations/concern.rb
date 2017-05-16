module Globalize
  module Validations
    module Concern
      extend ActiveSupport::Concern

      private

      # This validation will perform a validation round against each globalized locales
      # and add errors for globalized attributes names
      def validates_globalized_attributes
        # Only validates globalized attributes from the admin locale
        return unless Globalize.locale == I18n.locale

        # Define which locales to validate against
        locales = if globalize_validations_locales.respond_to?(:call)
                    globalize_validations_locales.call(self)
                  else
                    globalize_validations_locales
                  end
        locales ||= []

        globalized_errors = globalized_errors_for_locales(translated_attribute_names, locales)

        # Add translated attributes errors back to the object
        globalized_errors.each do |attribute, messages|
          messages.each do |message|
            errors.add(attribute, message)
          end
        end
      end

      # Return all translated attributes with errors for the given locales,
      # including their error messages
      def globalized_errors_for_locales(attribute_names, source_locales)
        locales = source_locales.map(&:to_s)
        additional_locales = locales - [I18n.locale.to_s]

        {}.tap do |globalized_errors|
          if locales.include? I18n.locale.to_s
            # Track errors for current locale
            globalized_errors.merge! globalized_errors_for_locale(attribute_names, I18n.locale)
          end

          # Validates the given object against each locale except the current one
          # and track their errors
          additional_locales.each do |locale|
            Globalize.with_locale(locale) do
              if invalid?
                globalized_errors.merge! globalized_errors_for_locale(attribute_names, locale)
              end
            end
          end
        end
      end

      # Return all translated attributes with errors for the given locale,
      # including their error messages
      def globalized_errors_for_locale(translated_attribute_names, locale)
        {}.tap do |globalized_errors|
          translated_attribute_names.each do |attribute|
            if (error = errors.messages.delete(attribute.to_sym)).present?
              globalized_errors["#{attribute}_#{locale.to_s.underscore}".to_sym] = error
            end
          end
        end
      end
    end
  end
end
