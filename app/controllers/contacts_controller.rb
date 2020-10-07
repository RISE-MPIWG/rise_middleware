class ContactsController < ApplicationController

  def create
    @contact = Contact.new(contact_params)
    if @contact.save
      ContactMailer.admin_notification(@contact).deliver_now
      ContactMailer.contact_notification(@contact).deliver_now
      redirect_to '/', notice: 'Your message was successfully sent.'
    else
      redirect_to '/'
    end
  end

  def contact_params
    params.fetch(:contact, {}).permit(:name, :email, :message)
  end
end
