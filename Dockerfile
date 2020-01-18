FROM ruby:2.6.5

RUN apt update -qqy && apt -qqy install nodejs

WORKDIR /tmp
ADD Gemfile* /tmp/

RUN gem install bundler:2.1.4
RUN bundle install --deployment -j4 --without development test

ADD . /app
WORKDIR /app
RUN cp -a /tmp/vendor/bundle /app/vendor/bundle && \
    bundle exec rake assets:precompile
CMD ["bundle", "exec", "foreman", "start", "-f", "Procfile.docker"]
