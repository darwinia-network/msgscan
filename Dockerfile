FROM ruby:3.1

# Dependencies
RUN apt-get update -qq && apt-get install -y cron postgresql-client

# Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&apt-get install -y nodejs

# Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config --global frozen 1

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN bundle install

COPY . .

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0"]