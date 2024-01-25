FROM ruby:3.0.2

RUN apt-get update && apt-get install -y firefox-esr build-essential libssl-dev xvfb

RUN wget https://github.com/mozilla/geckodriver/releases/download/v0.34.0/geckodriver-v0.34.0-linux64.tar.gz && \
    tar -xvzf geckodriver-v0.34.0-linux64.tar.gz && \
    chmod +x geckodriver && \
    mv geckodriver /usr/local/bin/

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . ./

CMD ["ruby", "crawler.rb"]
