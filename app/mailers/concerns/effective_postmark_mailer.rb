module EffectivePostmarkMailer
  extend ActiveSupport::Concern

  included do
    # Make sure config.action_mailer.raise_delivery_errors = true
    before_action(unless: -> { Rails.env.test? || Rails.env.development? }) do
      unless (Rails.application.config.action_mailer.raise_delivery_errors rescue false)
        raise("Expected config.action_mailer.raise_delivery_errors to be true. Please update your environment for use with effective_postmark.")
      end
    end

    rescue_from ::StandardError, with: :effective_postmark_error
    rescue_from ::Postmark::InactiveRecipientError, with: :effective_postmark_inactive_recipient_error
  end

  def effective_postmark_inactive_recipient_error(exception)
    # Read the current app's Tenant if defined
    tenant = if defined?(Tenant)
      Tenant.current || raise("Missing tenant in effective_postmark exception")
    end

    # Find the user to associate it with
    user_klass = (tenant ? Tenant.engine_user(tenant) : "User".safe_constantize)
    raise("Expected an effective_postmark_user") unless user_klass.try(:effective_postmark_user?)

    # All recipients
    recipients = (Array(exception.recipients) - [nil, "", " "]).map { |email| email.downcase.strip }

    # Find each user and mark them postmark_inactive and make a log
    recipients.each do |email|
      user = user_klass.find_for_database_authentication(email: email)

      if user.present?
        user.postmark_inactive_recipient!
      end

      ::EffectiveLogger.email("[ERROR] Inactive Recipient - #{email}", user: user, error_code: exception.error_code, message: exception.message)
    end

    true
  end

  def effective_postmark_error(exception)
    true
  end

end
