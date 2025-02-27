# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.3.6

FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" 

# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libpq-dev libvips pkg-config

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile
RUN curl -sL https://deb.nodesource.com/setup_20.x | bash -
RUN apt-get install nodejs npm --yes

# Copy application code
COPY . .

RUN npm install


# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libvips postgresql-client && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN useradd rails --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp

USER rails:rails

ARG RAILS_MASTER_KEY
ARG DB_HOST
ARG MASTODON_ACCESS_TOKEN 
ARG ALADIN_TTB_KEY
ARG POSTGRES_PASSWORD
ARG ALADIN_TELEGRAM_BOT_TOKEN
ARG ALADIN_TELEGRAM_CHANNEL_ID

ENV RAILS_MASTER_KEY=$RAILS_MASTER_KEY
ENV DB_HOST=$DB_HOST
ENV MASTODON_ACCESS_TOKEN=$MASTODON_ACCESS_TOKEN
ENV ALADIN_TTB_KEY=$ALADIN_TTB_KEY
ENV POSTGRES_PASSWORD=$POSTGRES_PASSWORD
ENV ALADIN_TELEGRAM_BOT_TOKEN=$ALADIN_TELEGRAM_BOT_TOKEN
ENV ALADIN_TELEGRAM_CHANNEL_ID=$ALADIN_TELEGRAM_CHANNEL_ID

RUN echo $RAILS_MASTER_KEY

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
