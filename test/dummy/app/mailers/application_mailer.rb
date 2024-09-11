class ApplicationMailer < ActionMailer::Base
  include EffectiveMailer
  include EffectivePostmarkMailer

  def welcome(user, opts = {})
    @user = user
    mail(to: user.email, from: EffectivePostmark.mailer_sender, subject: 'Welcome')
  end

end
