FROM ruby:2.4.5-jessie

RUN apt-get update && apt-get -y install nodejs

WORKDIR /tmp
ADD Gemfile* /tmp/
RUN bundle install --deployment -j4 --without development test

ADD . /app
WORKDIR /app
RUN cp -a /tmp/vendor/bundle /app/vendor/bundle && \
    bundle exec rake assets:precompile
CMD ["bundle", "exec", "foreman", "start", "-f", "Procfile.docker"]
