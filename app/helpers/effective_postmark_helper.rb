module EffectivePostmarkHelper

  # For use on the regular user alerts and forgot password pages
  def effective_postmark_alert(user, from: nil, html_class: 'alert alert-danger mb-4')
    raise('expected an effective_postmark_user') unless user.class.try(:effective_postmark_user?)
    return unless user.email_delivery_error.present?

    content_tag(:div, class: html_class) do
      [
        succeed(',') { "IMPORTANT: The email address you use to sign in#{" to #{from}" if from}" },
        succeed(',') { user.email },
        "has been marked as inactive.",
        "You will not receive any emails",
        ("from #{from}" if from),
        "while inactive.",
        "Please contact us to update your email address."
      ].compact.join(' ').html_safe
    end
  end

  # For use on the admin/users#edit page
  def effective_postmark_admin_alert(user, from: nil, html_class: 'alert alert-danger mb-4')
    raise('expected an effective_postmark_user') unless user.class.try(:effective_postmark_user?)
    return unless user.email_delivery_error.present?

    content_tag(:div, class: html_class) do
      [
        "This user has an inactive email address.",
        "They will not receive any emails",
        ("from #{from}" if from),
        "while inactive.",
        "Please update their email address, or " +
        link_to('reactivate their email', effective_postmark.postmark_reactivate_admin_postmark_path(user), 'data-method': :post),
        "and automatically attempt an email delivery."
      ].compact.join(' ').html_safe
    end
  end

end
