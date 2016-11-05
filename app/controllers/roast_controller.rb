class RoastController < ApplicationController

  def show
    @email = params[:email]
    @full_contact_json = FullContact.person(email: @email, style: 'dictionary')

    render json: @full_contact_json
  end

  #   respond_to do |format|
  #     format.html { redirect_to edit_admin_newsletter_import_path(@import), notice: t("activerecord.messages.created", model: controller_model_name) }
  #     format.json { render json: @import, status: :created, location: @import }
  # end


end
