FROM ruby:2.5.5-slim

MAINTAINER Pascal Belouin <pbelouin@mpiwg-berlin.mpg.de>

RUN apt-get update && apt-get install -my wget gnupg && apt-get update && apt-get install -qq -y --no-install-recommends \
      build-essential libpq-dev libxml2-dev curl
RUN apt-get install git -y

# Node.js
RUN curl -sL https://deb.nodesource.com/setup_8.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -\
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update \
    && apt-get install -y yarn

ENV INSTALL_PATH /rise

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH


COPY Gemfile ./
RUN gem install bundler
RUN bundle install
RUN bundle update --bundler
COPY Gemfile Gemfile
RUN gem update --system


COPY . .
RUN bundle exec rake assets:generate_json_translations
VOLUME ["$INSTALL_PATH/public"]

CMD bundle exec puma -C config/puma.rb
