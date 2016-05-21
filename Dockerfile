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

RUN gem install unicorn -v '5.1.0'

RUN bundle install

ENV SECRET_KEY_BASE nsodnsoineoin0203432320n2ewrndsfndsf2340s33i32i3ij3ns9

ENV RAILS_ENV production

ENV RAILS_SERVE_STATIC_FILES true

CMD bundle exec unicorn -c config/unicorn.rb


