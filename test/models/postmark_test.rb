require 'test_helper'

class PostmarkTest < ActiveSupport::TestCase
  test 'build_user is valid' do
    assert build_user().valid?
  end

  test 'regular email' do
    user = build_user()
    user.save!

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Mail::Message)
  end

  test 'bounced email' do
    user = build_user()
    user.update!(email: 'test@bounce-testing.postmarkapp.com')

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Exception)
  end

  test 'postmark inactive recipient methods' do
    user = build_user()
    user.save!

    assert user.email_delivery_error.blank?

    # Mark inactive
    user.postmark_inactive_recipient!

    assert user.email_delivery_error.present?
    assert_equal 'Inactive Recipient', user.email_delivery_error
    assert user.email_delivery_error_at.present?

    # Mark active again
    user.postmark_reactivate!
    assert user.email_delivery_error.blank?
  end

  test 'changing user email' do
    user = build_user()
    user.save!

    # Mark inactive
    user.postmark_inactive_recipient!
    assert user.email_delivery_error.present?

    user.update!(email: 'another@example.com')
    assert user.email_delivery_error.blank?
  end

  test 'bounced email from postmark' do
    user = build_user()
    user.update!(email: 'test@bounce-testing.postmarkapp.com')

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Exception)

    user.reload

    assert user.email_delivery_error.present?
    assert_equal 'Inactive Recipient', user.email_delivery_error
    assert user.email_delivery_error_at.present?

    log = Effective::Log.where(status: :email, user: user, message: "[ERROR] Inactive Recipient - #{user.email}").first
    assert log.present?
  end

  test 'exception email from postmark' do
    user = build_user()
    user.update!(email: 'InboundError@bounce-testing.postmarkapp.com')

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Mail::Message)

    assert user.email_delivery_error.blank?
  end
end
