require 'watir'
require 'pry'
require 'twilio-ruby'

class Crawler
  def initialize
    @sender = SmsSender.new
  end

  SUBSCRIBED = [
    "https://www.adidas.pl/spodnie-tiro/IM2899.html",
    "https://www.adidas.pl/spodnie-tiro/IM2899.html",
  ]

  NOT_INTERESTED = [
    "https://www.adidas.pl/rain.rdy-golf-pants/HK7447.html",
    "https://www.adidas.pl/rain.rdy-golf-pants/HI3463.html",
    "https://www.adidas.pl/spodnie-rain.rdy-golf/HZ5941.html",
    "https://www.adidas.pl/future-icons-badge-of-sport-pants/IC3759.html",
    "https://www.adidas.pl/essentials-single-jersey-tapered-elasticized-cuff-logo-pants/IC0056.html",
    "https://www.adidas.pl/spodnie-tiro/IM2900.html",
    "https://www.adidas.pl/spodnie-tiro/IS1522.html",
    "https://www.adidas.pl/techfit-aeroready-training-long-tights/HM6061.html",
    "https://www.adidas.pl/techfit-training-short-tights/HJ9921.html",
    "https://www.adidas.pl/spodnie-designed-for-training-yoga-training-7-8/IN7918.html",
    "https://www.adidas.pl/techfit-3-stripes-training-short-tights/HD3531.html",
    "https://www.adidas.pl/spodnie-designed-for-training-yoga-training-7-8/IN7919.html",
    "https://www.adidas.pl/spodnie-designed-for-training-yoga-training-7-8/IU4604.html",
  ]

  IGNORED_KEYWORDS = %w( terrex legginsy )

  def start
    links = []
    b = Watir::Browser.new :firefox, headless: true

    b.goto("https://www.adidas.pl/mezczyzni-odziez-spodnie?v_size_pl_pl=mt%7Clt")

    if b.text.include? "Zaakkceptuj monitorowanie"
      b.span(text: "Zaakceptuj monitorowanie").click
    end

    b.links(class: "glass-product-card__assets-link").each do |link|
      next if skip?(link.href)
      puts link.href
      links << link.href
    end
    if !links.empty?
      @sender.send_sms(links.join("\n"))
      puts links.join("\n")
    else
      puts "No links found"
    end
    b.close
  end

  def skip?(href)
    NOT_INTERESTED.include?(href) || SUBSCRIBED.include?(href) || skip_by_keyword?(href)
  end

  def skip_by_keyword?(href)
    IGNORED_KEYWORDS.each do |keyword|
      if href.include? keyword
        return true
      end
    end
    return false
  end
end

class SmsSender
  def initialize
    @account_sid = ENV['TWILIO_ACCOUNT_SID']
    @auth_token = ENV['TWILIO_AUTH_TOKEN']
    @twillio_phone_number = ENV['TWILIO_PHONE_NUMBER']
    @destination_number = ENV['DESTINATION_NUMBER']
    @client = Twilio::REST::Client.new(@account_sid, @auth_token)
  end

  def send_sms(message)
    @client.messages.create(
      from: @twillio_phone_number,
      to: @destination_number,
      body: message
    )
  end
end

Crawler.new.start
