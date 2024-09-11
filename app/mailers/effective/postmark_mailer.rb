module Effective
  class PostmarkMailer < EffectivePostmark.parent_mailer_class
    include EffectiveMailer
    include EffectivePostmarkMailer

    def reactivated(resource, opts = {})
      raise('expected an effective_postmark_user') unless resource.class.try(:effective_postmark_user?)

      @user = resource
      subject = subject_for(__method__, 'Email Reactivated', resource, opts)
      headers = headers_for(resource, opts)

      to = [resource.email, resource.try(:alternate_email).presence].compact

      mail(to: to, subject: subject, **headers)
    end

  end
end
