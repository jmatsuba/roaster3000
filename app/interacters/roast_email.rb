class RoastEmail
  include Interactor

  # Shared Variables
  BAD_FOLLOW_RATIO = -50

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
  rescue FullContact::NotFound
    puts "fuck"
    @name = "loser"
  end

  def build_jokes
    @level1_hash = {}
    @level2_hash = {}
    @level3_hash = {}
    @level4_hash = {}
    @level5_hash = {}

    #### test methods here

    # byebug

    if @full_contact
      myspace
      low_twitter_followers
      bad_twitter_ratio
      pinterest
      country
      state
      city
      google_plus
      foursqaure
      gravitar
      company
      twitter_bio
      has_website
      company_position
      has_phone_number
      fav_topics
      angellist
    end

  end

  def roast
    #stub = calculate best joke here
  end

  def build_json
    status = @full_contact.nil? ? "We can't find info you on, jerk" : "Ok check these out"
    {name: @name,
      status: status,
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
      puts 'success'
    end
  end

  def low_twitter_followers
    if @full_contact['social_profiles']['twitter'] && @full_contact['social_profiles']['twitter'][0]['followers'] < 200
      twitter_followers = @full_contact['social_profiles']['twitter'][0]['followers']
      @level1_hash['low_twiiter_followers'] = "You only have #{twitter_followers} twitter followers. No one follows you.  You suck"
    end
  end

  def bad_twitter_ratio
    return if  @full_contact['social_profiles']['twitter'].nil?
    followers = @full_contact['social_profiles']['twitter'][0]['followers']
    following = @full_contact['social_profiles']['twitter'][0]['following']

    if (followers - following) < BAD_FOLLOW_RATIO
      @level1_hash['bad_twitter_ratio'] = "You follow: #{following} | Who follows you: #{followers}, getting pretty desperate. #nobodylikesyou"
    end
  end

  def pinterest
    if @full_contact['social_profiles']['pinterest']
      @level1_hash['pinterest'] = "Great Pinterest account, now you can post cooking pics to yourself and also yourself."
    end
  end

  def country
    if @full_contact['demographics']['location_deduced']['country']['name'] == 'Canada'
      @level1_hash['country'] = "Where 14-year-old girls can walk home alone at 11:00pm."
    end
  end

  def state
    if @full_contact['demographics']['location_deduced']['state']['name'] == 'British Columbia'
      @level1_hash['state'] = "Land of weed and hippies."
    end
  end

  def city
    if @full_contact['demographics']['location_deduced']['city']['name'] == 'Vancouver'
      @level1_hash['city'] = "That city where if you own a house already, you can sell it and buy a cruise liner."
    end
  end

  def google_plus
    if @full_contact['social_profiles']['google_plus']
      @level1_hash['google_plus'] = "Just shoot yourself...then post it on Google+ where no one cares."
    end
  end

  def foursqaure
    #stub
  end

  def gravitar
    #stub
  end

  def company
    #stub
  end

  def twitter_bio
    #stub
  end

  def has_website
    #stub
  end

  def company_position
    #stub
  end

  def has_phone_number
    #stub
  end

  def fav_topics
    #stub
  end

  def angellist
    #stub
  end

end
