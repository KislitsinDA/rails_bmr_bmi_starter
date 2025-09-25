FROM ruby:3.2

RUN apt-get update -qq && apt-get install -y --no-install-recommends     build-essential libpq-dev curl git && rm -rf /var/lib/apt/lists/*

# Install Rails globally to allow `rails new`
RUN gem install rails -v "~>7.1" && gem install bundler

WORKDIR /app

# Copy entrypoint and mark executable
COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

EXPOSE 3000
