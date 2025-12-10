class ApplicationMailer < ActionMailer::Base
  layout 'mailer'

  default from: ENV.fetch('MAILER_FROM_EMAIL', nil)
end
