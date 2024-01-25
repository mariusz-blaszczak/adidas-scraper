require 'watir'
require 'pry'

class Crawler

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
    # "https://www.adidas.pl/spodnie-designed-for-training-yoga-training-7-8/IU4604.html",
  ]

  IGNORED_KEYWORDS = %w( terrex legginsy )

  def start
    b = Watir::Browser.new :firefox, headless: true

    b.goto("https://www.adidas.pl/mezczyzni-odziez-spodnie?v_size_pl_pl=mt%7Clt")

    if b.text.include? "Zaakkceptuj monitorowanie"
      b.span(text: "Zaakceptuj monitorowanie").click
    end

    b.links(class: "glass-product-card__assets-link").each do |link|
      next if skip?(link.href)
      puts link.href
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

Crawler.new.start
