FROM rails:4.2

EXPOSE 8002

RUN mkdir app

COPY documentator app

WORKDIR /app

RUN gem install byebug -v '9.0.4'

RUN gem install debug_inspector -v '0.0.2'

RUN gem install byebug -v '8.2.4'

RUN gem install sqlite3 -v '1.3.11'

RUN gem install binding_of_caller -v '0.7.2'

RUN gem install unf_ext -v '0.0.7.2'

RUN gem install kgio -v '2.10.0'

RUN gem install raindrops -v '0.16.0'

RUN bundle install

ENV SECRET_KEY_BASE ./bin/rake secret

# Provide dummy data to Rails so it can pre-compile assets.
RUN bundle exec rake RAILS_ENV=production SECRET_KEY_BASE=$SECRET_KEY_BASE

CMD bundle exec unicorn -c config/unicorn.rb


