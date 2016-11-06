class RoastController < ApplicationController
  def show
    @email = params[:email]
    @twitter = params[:twitter]

    result = ::RoastEmail.call(email: @email, twitter: @twitter)

    render status: 200, json: result.json

    # respond_to do |format|
    #   format.json { render json: result.json, head :ok }
    # end
  end

  def fullcontact
    @email = params[:email]
    @twitter = params[:twitter]
    if @email
      @full_contact_json = FullContact.person(email: @email, style: 'dictionary')
    else
      @full_contact_json = FullContact.person(twitter: @twitter, style: 'dictionary')
    end

    # render json: @full_contact_json, status: 200
    render status: 200, json: @full_contact_json
  end
end
