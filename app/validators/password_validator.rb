class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value.to_s.match(Constants::PASSWORD_REGEX)

    record.errors.add attribute, (options[:message] || I18n.t('validation.password_validation_message'))
  end
end
