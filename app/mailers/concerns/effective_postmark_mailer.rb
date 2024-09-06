module EffectivePostmarkMailer
  extend ActiveSupport::Concern

  included do
    rescue_from Postmark::InactiveRecipientError, with: :effective_postmark_inactive_recipient_error
  end

  def effective_postmark_inactive_recipient_error(exception)
    recipients = Array(exception.recipients) - [nil, "", " "]

    recipients.each do |email|
      # todo
    end

    # Effective::Log.log(exception.message, recipients: recipients)

    true
  end

end
