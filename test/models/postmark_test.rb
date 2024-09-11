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

    assert user.postmark_valid?

    # Mark inactive
    user.postmark_inactive_recipient!

    assert user.postmark_invalid?
    assert_equal 'Inactive Recipient', user.postmark_error
    assert user.postmark_error_at.present?

    # Mark active again
    user.postmark_reactivate!
    assert user.postmark_valid?
  end

  test 'changing user email' do
    user = build_user()
    user.save!

    # Mark inactive
    user.postmark_inactive_recipient!
    assert user.postmark_invalid?

    user.update!(email: 'another@example.com')
    assert user.postmark_valid?
  end

  test 'bounced email from postmark' do
    user = build_user()
    user.update!(email: 'test@bounce-testing.postmarkapp.com')

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Exception)

    user.reload

    assert user.postmark_invalid?
    assert_equal 'Inactive Recipient', user.postmark_error
    assert user.postmark_error_at.present?

    log = Effective::Log.where(status: :email, user: user, message: "[ERROR] Inactive Recipient - #{user.email}").first
    assert log.present?
  end

  test 'exception email from postmark' do
    user = build_user()
    user.update!(email: 'InboundError@bounce-testing.postmarkapp.com')

    message = ApplicationMailer.welcome(user).deliver_now
    assert message.kind_of?(Mail::Message)

    assert user.postmark_valid?
  end
end
