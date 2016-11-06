class RoastEmail
  include Interactor

  # Shared Variables
  BAD_FOLLOW_RATIO = -50

  SN = ["facebook", "twitter", "google", "foursquare", "gravatar", "angellist", "pinterest"]

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
    @generic_info_hash = {}
    @level1_hash = {}
    @level2_hash = {}
    @level3_hash = {}
    @level4_hash = {}
    @level5_hash = {}

    #### test methods here

    # byebug


    if @full_contact
      full_name
      given_name
      family_name
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
      sn_bio
      has_website
      company_position
      fav_topics
      angellist
      urban_dictionary_def
    end

  end

  def roast
    #stub = calculate best joke here
  end

  def build_json
    status = @full_contact.nil? ? "We can't find info you on, jerk" : "Ok check these out"
    {name: @name,
      status: status,
      generic_info: @generic_info_hash,
      level1: @level1_hash,
      level2: @level2_hash,
      level3: @level3_hash,
      level4: @level4_hash,
      level5: @level5_hash}.to_json
  end

  def check_sentiment(text)
    response = Unirest.post "https://community-sentiment.p.mashape.com/text/",
      headers:{
        "X-Mashape-Key" => "aIQI5BkKWImshommfVzlfhgfe3Mjp1zlK6HjsngXw2SrocsgPh",
        "Content-Type" => "application/x-www-form-urlencoded",
        "Accept" => "application/json"
      },
      parameters:{
        "txt" => text
      }
  end

  # GENERIC INFO

  def full_name
    if @full_contact['contact_info']['full_name']
      @generic_info_hash['full_name'] = @full_contact['contact_info']['full_name']
    end
  end

  def given_name
    if @full_contact['contact_info']['given_name']
      @generic_info_hash['given_name'] = @full_contact['contact_info']['given_name']
    end
  end

  def family_name
    if @full_contact['contact_info']['family_name']
      @generic_info_hash['family_name'] = @full_contact['contact_info']['family_name']
    end
  end

  # INDIVIDUAL JOKES LOGIC
  def myspace
    if @full_contact['social_profiles']['myspace']
      @level1_hash['myspace'] = "You have a Myspace account.  You are a wanker for having this."
      puts 'success'
    end
  end

  def low_twitter_followers
    if @full_contact['social_profiles']['twitter'] && @full_contact['social_profiles']['twitter'][0]['followers'] && @full_contact['social_profiles']['twitter'][0]['followers'] < 200
      twitter_followers = @full_contact['social_profiles']['twitter'][0]['followers']
      @level1_hash['low_twiiter_followers'] = "You only have #{twitter_followers} twitter followers. No one follows you.  You suck"
    end
  end

  def bad_twitter_ratio
    return if  @full_contact['social_profiles']['twitter'].nil? || @full_contact['social_profiles']['twitter'][0]['followers'].nil?
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

  def location_deduced?
    @full_contact['demographics']&&@full_contact['demographics']['location_deduced']
  end

  def country
    return if !location_deduced?
    if @full_contact['demographics']['location_deduced']['country']&&@full_contact['demographics']['location_deduced']['country']['name'] == 'Canada'
      @level1_hash['country'] = "Where 14-year-old girls can walk home alone at 11:00pm."
    end
  end

  def state
    return if !location_deduced?
    if @full_contact['demographics']['location_deduced']['state']['name'] == 'British Columbia'
      @level1_hash['state'] = "Land of weed and hippies."
    end
  end

  def city
    return if !location_deduced?
    if @full_contact['demographics']['location_deduced']['city']&&@full_contact['demographics']['location_deduced']['city']['name'] == 'Vancouver'
      @level1_hash['city'] = "That city where if you own a house already, you can sell it and buy a cruise liner."
    end
  end

  def google_plus
    if @full_contact['social_profiles']['google_plus']
      @level1_hash['google_plus'] = "Just shoot yourself...then post it on Google+ where no one cares."
    end
  end

  def foursqaure
    if @full_contact['social_profiles']['foursqaure']
      @level1_hash['foursqaure'] = "Checkin at your mom's fav strip just to find out that no one cares"
    end
  end

  def gravitar
    if @full_contact['social_profiles']['gravitar']
      @level1_hash['gravitar'] = "Found your gravitar pic, now everyone can find your profile pic from your shitty Wordpress site"
    end
  end

  def company

  end

  def sn_bio
    bio = "I'm a wanker. I enjoy wanking."
    SN.each do |x|
      if @full_contact['social_profiles'][x] && @full_contact['social_profiles'][x][0]['bio']
        bio = @full_contact['social_profiles'][x][0]['bio']
      end
    end
    @level1_hash['sn_bio'] = "#{bio} <cough> Loser! <cough>"
  end

  def has_website
    website_url = @full_contact['contact_info']['website']
    if website_url
      @level2_hash['website'] = "Why does your website (#{website_url}) redirect to pornhub.com/husky-bitches?"
    end
  end

  def scrape_linked_in(url)
    agent ||= Mechanize.new
    agent.user_agent = 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_11_6) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/54.0.2840.71 Safari/537.36'
    page = agent.get(url)

    doc = Nokogiri::HTML(page.parser.to_s.force_encoding("UTF-8"))
    @linked_in_title = doc.css(".item-title")[0].text
    @linked_in_company = doc.css(".item-subtitle")[0].text
  rescue Mechanize::ResponseCodeError
    puts 'CODE 999 linked in scrape failed'
    return false
  end


  def company_position
    linked_in = @full_contact['social_profiles']['linkedin']
    full_contact_org = @full_contact['organizations'].nil? ? nil : @full_contact['organizations'][0]

    if linked_in && scrape_linked_in(linked_in[0]['url'])
      positions = [@linked_in_title]
    elsif full_contact_org
      positions = @full_contact['organizations'].map {|x| x['title']}.compact
    else
      return
    end

    full_matches = []

    positions.each do |position|
      titles = [
        { pattern: /\bdeveloper|\bDeveloper|\bdev|\bDev/, joke:"HAHA  #{position} -- Arn't all devs socially akward... and you know.. ugly"},
        { pattern: /\bdesigner|\bDesigner|\bDesign|\bdesign/, joke:"HAHA #{position} -- Arn't all designers... you know.. brainless"},
        { pattern: /\bintern|\bIntern|\bInternship|\binternship/, joke:"HAHA #{position} -- Arn't all interns... you know.. newbs"},
        { pattern: /\bmarketing|\bMarketing/, joke:"HAHA #{position} --  Arn't all marketers... agressive and manipulative??? Get away from me!"},
        { pattern: /\bsocial|\bScocial/, joke:"HAHA #{position} -- You work in social media? is that even a real job?"},
        { pattern: /\bcomedian|\bComedian|\bcomic|\bComic/, joke:"HAHA #{position} -- Your actually NOT funny..... and probably a broke entertainer."}
      ]
      matches = titles.select {|t| position.match(t[:pattern])}
      full_matches << matches[0] if matches[0]
    end
    # matches = titles.select {|t| position.match(t[:pattern])}

    @level2_hash['company_position'] = full_matches[0][:joke] if full_matches.size > 0
  end

  def has_phone_number
    #stub
  end

  def fav_topics
    #stub
  end

  def angellist
    if @full_contact['angellist']
      @level1_hash['angellist'] = "The only investing you will get your angellist site is from pedofiles.io"
    end
  end

  def urban_dictionary_def
    term_to_define = @full_contact['contact_info']['given_name']
    response = Unirest.get "https://mashape-community-urban-dictionary.p.mashape.com/define?term=#{term_to_define}",
      headers:{
        "X-Mashape-Key" => "aIQI5BkKWImshommfVzlfhgfe3Mjp1zlK6HjsngXw2SrocsgPh",
        "Accept" => "text/plain"
      }
    if response
      response.body['list'].each do |item|
        # item_sentiment = check_sentiment(item['example'])
        # sentiment = item_sentiment.body['result']['sentiment']
        # confidence = item_sentiment.body['result']['confidence']

        # if ( item_sentiment['confidence'].to_i > 70 ) && item_sentiment['sentiment'] == 'negative'
          @level1_hash['urban_dictionary_def'] = item['example']
        # end
      end
    end
  end

  def urban_dictionary_tags
    tag_array = []
    term_to_define = @full_contact['contact_info']['given_name']
    response = Unirest.get "https://mashape-community-urban-dictionary.p.mashape.com/define?term=#{term_to_define}",
      headers:{
        "X-Mashape-Key" => "aIQI5BkKWImshommfVzlfhgfe3Mjp1zlK6HjsngXw2SrocsgPh",
        "Accept" => "text/plain"
      }
    if response
      response.body['tags'].each do |item|
        # item_sentiment = check_sentiment(item)
        # sentiment = item['sentiment']
        # confidence = item['confidence']

        # if ( item_sentiment['confidence'].to_i > 70 ) && item_sentiment['sentiment'] == 'negative'
          tag_array.push(item)
          @level1_hash['urban_dictionary_tags'] = tag_array
        # end
      end
    end
  end

end
