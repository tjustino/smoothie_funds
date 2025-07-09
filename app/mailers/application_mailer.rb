# Setup used to generate email message
class ApplicationMailer < ActionMailer::Base
  default from: "noreply@smoothiefunds.com"
  layout "mailer"
  before_action :attach_logo

  private ##############################################################################################################

    def attach_logo
      attachments.inline["logo.svg"] = File.read Rails.root.join("app", "assets", "images", "_icon.svg")
    end
end
