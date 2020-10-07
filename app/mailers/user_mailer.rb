class UserMailer < ApplicationMailer
  def job_finished_notification(user)
    @user = user
    mail(to: @user.email, subject: 'Rise Job Complete')
  end

  def registration_confirmation_notification(email, password)
    @email = email
    @password = password
    mail(to: @email, subject: 'Your new RISE account is ready!')
  end
end
