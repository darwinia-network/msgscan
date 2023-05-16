FROM ruby:3.1

# Dependencies
RUN apt-get update -qq && apt-get install -y cron postgresql-client vim

# Node
RUN curl -fsSL https://deb.nodesource.com/setup_18.x | bash - &&apt-get install -y nodejs

# Rust
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y
ENV PATH="/root/.cargo/bin:${PATH}"

WORKDIR /usr/src/app
COPY Gemfile Gemfile.lock ./
RUN gem install bundler && bundle install

COPY . .

CMD [ "/bin/sh" ]