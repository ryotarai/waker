FROM ruby:2.2.0

RUN apt-get update && apt-get -y install nodejs

WORKDIR /tmp
ADD Gemfile /tmp/Gemfile
ADD Gemfile.lock /tmp/Gemfile.lock
RUN bundle install --deployment -j4

ADD . /app
WORKDIR /app
RUN cp -a /tmp/vendor/bundle /app/vendor/bundle && \
    bundle exec rake assets:precompile
CMD bundle exec foreman start -f Procfile.docker

