class RoastController < ApplicationController


  def show
    @email = params[:input] if email? params[:input]
    @twitter = params[:input] if twitter? params[:input]

    result = ::RoastEmail.call(email: @email, twitter: @twitter)
    render status: 200, json: result.json
  end

  def fullcontact
    @email = params[:email]
    @twitter = params[:twitter]
    if @email
      @full_contact_json = FullContact.person(email: @email, style: 'dictionary')
      puts 'USING EMAIL!!!!!!'
    else
      @full_contact_json = FullContact.person(twitter: @twitter, style: 'dictionary')
      puts 'USING TWITTER!!!!!!'
    end

    # render json: @full_contact_json, status: 200
    render status: 200, json: @full_contact_json
  end

  private

  def email?(input)
    return if input.nil?
    pattern = /.+\@.+\..+/
    input.match(pattern)
  end

  def twitter?(input)
    return if input.nil?
    pattern = /^@?(\w){1,15}$/
    input.match(pattern)
  end
end
