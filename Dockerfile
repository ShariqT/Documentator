FROM rails:4.2

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app

RUN rm -f Gemfile.lock

RUN bundle update debugger

ENTRYPOINT bundle install --system

CMD bin/rails server -e production