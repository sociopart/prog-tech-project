ARG RUBY_VERSION=3.1
ARG NODE_MAJOR_V=18

FROM ruby:$RUBY_VERSION

# Adding repositories to source list.
RUN curl -fsSL https://deb.nodesource.com/setup_$NODE_MAJOR_V.x | bash -

RUN curl -sL https://dl.yarnpkg.com/debian/pubkey.gpg | gpg --dearmor | tee /usr/share/keyrings/yarnkey.gpg >/dev/null
RUN echo "deb [signed-by=/usr/share/keyrings/yarnkey.gpg] https://dl.yarnpkg.com/debian stable main" | tee /etc/apt/sources.list.d/yarn.list

# Install necessary packages.
RUN apt-get update -qq && apt-get install -y postgresql-client nodejs yarn

# Prepare working directory.
WORKDIR /rufans
COPY ./rufans /rufans
RUN gem install bundler
RUN bundle install

# Configure endpoint.
COPY ./.docker/rufans/entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3000

# Start app server.
CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
