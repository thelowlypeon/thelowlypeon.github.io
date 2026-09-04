FROM ruby:3.4.10-slim

RUN apt-get update \
    && apt-get install -y --no-install-recommends build-essential \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /app

COPY Gemfile Gemfile.lock /app/
RUN bundle install

COPY . /app

ENTRYPOINT ["bundle", "exec", "jekyll"]

CMD ["serve", "--host", "0.0.0.0"]
