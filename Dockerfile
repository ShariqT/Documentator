FROM rails:4.2

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app

RUN gem install byebug -v '9.0.4'

RUN gem install debug_inspector -v '0.0.2'

RUN gem install byebug -v '8.2.4'

RUN gem install sqlite3 -v '1.3.11'

RUN bundle install

CMD bin/rails server -e production