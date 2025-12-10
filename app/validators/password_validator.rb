class PasswordValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    return if value.blank?
    return if value.to_s.length >= 6 && value.to_s.match(/(?=.*?[A-Z])/) && value.to_s.match(/(?=.*?[0-9])/) && value.to_s.match(/(?=.*?[#?!@$%^&*-._()])/)

    record.errors.add attribute, (options[:message] || I18n.t('validation.password_validation_message'))
  end
end
