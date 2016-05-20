FROM rails:4.2.6

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app

CMD ["bin/rails", "s", "-e production"]  