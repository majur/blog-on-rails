# syntax = docker/dockerfile:1

# Make sure RUBY_VERSION matches the Ruby version in .ruby-version and Gemfile
ARG RUBY_VERSION=3.4.2
FROM registry.docker.com/library/ruby:$RUBY_VERSION-slim as base

# Rails app lives here
WORKDIR /rails

# Install base packages
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl libjemalloc2 libvips sqlite3 libsqlite3-0 libyaml-dev && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Set production environment
ENV RAILS_ENV="production" \
    BUNDLE_DEPLOYMENT="1" \
    BUNDLE_PATH="/usr/local/bundle" \
    BUNDLE_WITHOUT="development"


# Throw-away build stage to reduce size of final image
FROM base as build

# Install packages needed to build gems and assets
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y build-essential git libvips pkg-config libyaml-dev \
    curl nodejs npm && \
    npm install -g yarn

# Install application gems
COPY Gemfile Gemfile.lock ./
RUN bundle install && \
    rm -rf ~/.bundle/ "${BUNDLE_PATH}"/ruby/*/cache "${BUNDLE_PATH}"/ruby/*/bundler/gems/*/.git && \
    bundle exec bootsnap precompile --gemfile

# Copy application code
COPY . .

# Install JS dependencies
RUN yarn install

# Precompile bootsnap code for faster boot times
RUN bundle exec bootsnap precompile app/ lib/

# Precompiling assets for production without requiring secret RAILS_MASTER_KEY
RUN NODE_OPTIONS=--openssl-legacy-provider SECRET_KEY_BASE_DUMMY=1 ./bin/rails assets:precompile


# Final stage for app image
FROM base

# Install packages needed for deployment
RUN apt-get update -qq && \
    apt-get install --no-install-recommends -y curl nodejs && \
    rm -rf /var/lib/apt/lists /var/cache/apt/archives

# Copy built artifacts: gems, application
COPY --from=build /usr/local/bundle /usr/local/bundle
COPY --from=build /rails /rails

# Run and own only the runtime files as a non-root user for security
RUN groupadd --system --gid 1000 rails && \
    useradd rails --uid 1000 --gid 1000 --create-home --shell /bin/bash && \
    chown -R rails:rails db log storage tmp public
USER rails:rails

# Entrypoint prepares the database.
ENTRYPOINT ["/rails/bin/docker-entrypoint"]

# Start the server by default, this can be overwritten at runtime
EXPOSE 3000

# Pridanie explicitnej zdravotnej kontroly - robustnejší prístup
# HEALTHCHECK --interval=10s --timeout=100s --start-period=15s --retries=5 \
#   CMD curl -f http://localhost:3000/up || exit 1

# Spusť priamo Rails server
CMD ["./bin/rails", "server", "-b", "0.0.0.0", "-p", "3000"]
