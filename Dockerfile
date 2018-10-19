FROM ruby:2.5-slim-stretch

ENV RAILS_ENV=development
ENV REDMINE_LANG=en

RUN apt-get update && \
        apt-get install -y --no-install-recommends gcc git make imagemagick libmagickwand-dev libsqlite3-dev && \
        cd /usr/src && \
        git clone --depth 1 https://github.com/redmine/redmine.git

WORKDIR /usr/src/redmine

COPY database.yml config

RUN bundle install && \
        bundle exec rake generate_secret_token && \
        bundle exec rake db:migrate && \
        bundle exec rake redmine:load_default_data --trace

EXPOSE 3000

CMD bundle exec rails server webrick -e "$RAILS_ENV" -b 0.0.0.0
