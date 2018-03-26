# frozen_string_literal: true

# Setup used to generate email message
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@smoothiefunds.com"
  layout "mailer"
end
