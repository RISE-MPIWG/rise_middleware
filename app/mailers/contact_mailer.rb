class ContactMailer < ApplicationMailer
  def contact_notification(contact)
    @contact = contact
    mail(to: @contact.email, subject: 'We have received your message!')
  end

  def admin_notification(contact)
  	@contact = contact
    mail(to: 'info-rise@mpiwg-berlin.mpg.de', subject: 'A new message has been sent from the RISE homepage')
  end
end
