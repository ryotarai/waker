FROM ruby:2.3

RUN apt-get update && apt-get -y install nodejs

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --deployment -j4 --without development test

ADD . /app
WORKDIR /app
RUN cp -a /tmp/vendor/bundle /app/vendor/bundle && \
    bundle exec rake assets:precompile && \
    mkdir -p /var/www/app && \
    cp -r /app/public /var/www/app/

VOLUME /var/www/app

CMD ["bundle", "exec", "foreman", "start", "-f", "Procfile.docker"]
