FROM rails:4.26

EXPOSE 3000

RUN mkdir app

COPY documentator app

WORKDIR /app/documentator

CMD ["bin/rails", "s", "-e production"]  