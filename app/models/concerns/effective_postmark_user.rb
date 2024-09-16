# EffectivePostmarkUsr
#
# Mark your user model with effective_postmark_user
#
# #<Postmark::InactiveRecipientError: You tried to send to recipient(s) that have been marked as inactive. Found inactive addresses: test@bounce-testing.postmarkapp.com. Inactive recipients are ones that have generated a hard bounce, a spam complaint, or a manual suppression.>

module EffectivePostmarkUser
  extend ActiveSupport::Concern

  module Base
    def effective_postmark_user
      include ::EffectivePostmarkUser
    end
  end

  included do
    effective_resource do
      email_delivery_error      :string
      email_delivery_error_at   :datetime
    end

    # Clear any email errors if they change their email
    before_validation(if: -> { email_changed? && email_delivery_error.present? }) do
      assign_attributes(email_delivery_error: nil, email_delivery_error_at: nil)
    end

    scope :with_email_delivery_errors, -> { where.not(email_delivery_error: nil) }
  end

  module ClassMethods
    def effective_postmark_user?; true; end
  end

  # Triggered by the EffectivePostmarkMailer concern when a Postmark::InactiveRecipientError is raised
  def postmark_inactive_recipient!
    return if email_delivery_error.present? # If we already marked invalid, don't mark again

    update_columns(email_delivery_error: 'Inactive Recipient', email_delivery_error_at: Time.zone.now)
  end

  # Triggered by an admin to reactivate the email address
  def postmark_reactivate!
    # Make an API request to reactivate this user
    EffectivePostmark.api.reactivate(self)

    # Send a reactivation email.
    # This could fail again and call postmark_inactive_recipient! behind the scenes
    message = EffectivePostmark.mailer_class.send(:reactivated, self).deliver_now
    return false if message.kind_of?(Exception)

    # This worked. We've been reactivated. Clear the error
    update_columns(email_delivery_error: nil, email_delivery_error_at: nil)
  end

end
