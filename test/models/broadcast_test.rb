require 'test_helper'

class PostmarkTest < ActiveSupport::TestCase
  test 'broadcast stream email' do
    user = build_user()
    user.save!

    message = ApplicationMailer.welcome_broadcast(user).deliver_now
    assert message.kind_of?(Mail::Message)
  end

  test 'bounced broadcast email' do
    user = build_user()
    user.update!(email: 'test@bounce-testing.postmarkapp.com')
    assert user.email_delivery_error.blank?

    message = ApplicationMailer.welcome_broadcast(user).deliver_now

    suppressions = EffectivePostmark.api.suppressions()
    suppression = suppressions.find { |suppression| suppression[:email_address] == user.email }
    assert suppression.present?

    # Rake task
    EffectivePostmark.api.assign_email_delivery_errors!(user.class)
    user.reload

    assert user.email_delivery_error.present?

    # Mark active again
    user.postmark_reactivate!
    assert user.email_delivery_error.blank?
  end

end
