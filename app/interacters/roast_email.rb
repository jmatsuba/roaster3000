class RoastEmail
  include Interactor

  def call
    @email = context.email
    fetch_full_contact
    build_jokes
    roast
    context.json = build_json
    puts @one_liner
  end

  # private

  # HELPERS
  def fetch_full_contact
    @full_contact = FullContact.person(email: @email, style: 'dictionary')
    @name = @full_contact['contact_info']['given_name'] ? @full_contact['contact_info']['given_name'] : "Loser"
  end

  def build_jokes
    @level1_hash = {}
    @level2_hash = {}
    @level3_hash = {}
    @level4_hash = {}
    @level5_hash = {}
    myspace
    low_twitter_followers
  end

  def roast
    #stub = calculate best joke here
  end

  def build_json
    {name: @name,
      level1: @level1_hash,
      level2: @level2_hash,
      level3: @level3_hash,
      level4: @level4_hash,
      level5: @level5_hash}.to_json
  end

  # INDIVIDUAL JOKES LOGIC
  def myspace
    if @full_contact['social_profiles']['myspace']
      @level1_hash['myspace'] = "You have a Myspace account.  You are a wanker for having this."
    end
  end

  def low_twitter_followers
    if @full_contact['social_profiles']['twitter'] && @full_contact['social_profiles']['twitter'][0]['followers'] < 200
      twitter_followers = @full_contact['social_profiles']['twitter'][0]['followers']
      @level1_hash['low_twiiter_followers'] = "You only have #{@twitter_followers} twitter followers. No one follows you.  You suck"
    end
  end

end
