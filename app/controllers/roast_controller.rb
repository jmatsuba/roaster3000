class RoastController < ApplicationController
  def show
    @email = params[:email]
    result = RoastEmail.call(email: @email)

    render json: result.json
  end

  def fullcontact
    @email = params[:email]
    @full_contact_json = FullContact.person(email: @email, style: 'dictionary')

    render json: @full_contact_json
  end
end
