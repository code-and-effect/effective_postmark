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
      postmark_error      :string
      postmark_error_at   :datetime
    end

    scope :postmark_inactive_recipients, -> { where.not(postmark_error_at: nil) }
  end

  module ClassMethods
    def effective_postmark_user?; true; end
  end

  # Triggered by the EffectivePostmarkMailer concern when a Postmark::InactiveRecipientError is raised
  def postmark_inactive_recipient!
    return unless postmark_valid? # If we already marked invalid, don't mark again

    update_columns(postmark_error: 'Inactive Recipient', postmark_error_at: Time.zone.now)
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
    update_columns(postmark_error: nil, postmark_error_at: nil)
  end

  def postmark_valid?
    postmark_error.blank?
  end

  def postmark_invalid?
    postmark_error.present?
  end

end
