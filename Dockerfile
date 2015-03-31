# Derived from rails:onbuild -- https://github.com/docker-library/rails/blob/2c0ee48228c1286e53001f0b95fa28e7524b57cd/onbuild/Dockerfile

FROM ruby:2.2.1

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*
RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && rm -rf /var/lib/apt/lists/*

# This allows for a second container to be run for the same image with "cron" as the command
RUN apt-get update && apt-get install -y cron
ADD import_crontab.txt /etc/cron.d/import-cron
RUN chmod 0644 /etc/cron.d/import-cron

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY Gemfile /usr/src/app/
COPY Gemfile.lock /usr/src/app/
RUN bundle install

COPY . /usr/src/app

EXPOSE 3000
CMD ["rails", "server", "-b", "0.0.0.0"]

