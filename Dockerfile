FROM rails:4.2

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app

ENTRYPOINT bundle install