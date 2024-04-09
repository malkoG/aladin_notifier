# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.1.3

FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development" 


RUN --mount=type=secret,id=MASTODON_ACCESS_TOKEN \
    export MASTODON_ACCESS_TOKEN=$(cat /run/secrets/MASTODON_ACCESS_TOKEN) 

RUN --mount=type=secret,id=ALADIN_TTB_KEY \
    export ALADIN_TTB_KEY=$(cat /run/secrets/ALADIN_TTB_KEY) 



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
RUN npm install

# Copy application code
COPY . .

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

# Entrypoint prepares the database.
RUN --mount=type=secret,id=POSTGRES_PASSWORD \
    export POSTGRES_PASSWORD=$(cat /run/secrets/POSTGRES_PASSWORD)

RUN --mount=type=secret,id=DB_HOST \
	export DB_HOST=$(cat /run/secrets/DB_HOST)

RUN --mount=type=secret,id=RAILS_MASTER_KEY \
    export RAILS_MASTER_KEY=$(cat /run/secrets/RAILS_MASTER_KEY) 

ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000
CMD ["./bin/rails", "server"]
