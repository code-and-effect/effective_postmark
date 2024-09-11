module EffectivePostmarkTestHelper

  def sign_in(user = create_user!)
    login_as(user, scope: :user); user
  end

  def as_user(user, &block)
    sign_in(user); yield; logout(:user)
  end

  def with_time_travel(date, &block)
    begin
      Timecop.travel(date); yield
    ensure
      Timecop.return
    end
  end

end
