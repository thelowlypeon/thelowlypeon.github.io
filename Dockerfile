FROM ruby:2.7.1-alpine

RUN apk add --update \
    build-base

WORKDIR /app
COPY . /app

RUN bundle install

ENTRYPOINT ["bundle", "exec", "jekyll"]

CMD ["serve", "--host", "0.0.0.0"]
