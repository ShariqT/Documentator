FROM rails:4.2

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app

RUN gem install byebug -v '9.0.4'

RUN bundle install --system

CMD bin/rails server -e production