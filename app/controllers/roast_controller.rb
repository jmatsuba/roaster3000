class RoastController < ApplicationController
  def show
    @email = params[:email]
    result = ::RoastEmail.call(email: @email)


    render status: 200, json: result.json

    # respond_to do |format|
    #   format.json { render json: result.json, head :ok }
    # end
  end

  def fullcontact
    @email = params[:email]
    @full_contact_json = FullContact.person(email: @email, style: 'dictionary')

    # render json: @full_contact_json, status: 200
    render status: 200, json: @full_contact_json
  end
end
