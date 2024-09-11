class ApplicationMailer < ActionMailer::Base
  include EffectiveMailer
  include EffectivePostmarkMailer

  def welcome(user, opts = {})
    @user = user
    mail(to: user.email, from: 'errors@codeandeffect.com', subject: 'Welcome')
  end

end
