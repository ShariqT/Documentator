FROM ruby:2.3

RUN apt-get update && apt-get install -y nodejs --no-install-recommends && rm -rf /var/lib/apt/lists/*

RUN apt-get update && apt-get install -y mysql-client postgresql-client sqlite3 --no-install-recommends && libxml2-dev libxslt1-dev && rm -rf /var/lib/apt/lists/*

ENV RAILS_VERSION 4.2.6

RUN gem install rails --version "$RAILS_VERSION"

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app/documentator

CMD ["bin/rails", "s", "-e production"]  