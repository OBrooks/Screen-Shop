class ApplicationMailer < ActionMailer::Base
  require 'mailjet'
  default from: 'william.horel@gmail.com'
  layout 'mailer'
end
