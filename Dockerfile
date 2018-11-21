# ruby build stage
FROM ruby:2.5-alpine as ruby-build-env
MAINTAINER mdouchement

# Set the locale
ENV LANG c.UTF-8

# App
ENV GEM_HOME /usr/src/app/vendor/gems
ENV GEM_PATH /usr/src/app/vendor/gems
ENV RAILS_ENV production
ENV RACK_ENV production
# Namespace for the application. Necessary for the asset compilation
# Update as needed
# ENV RAILS_RELATIVE_URL_ROOT /mersea
ENV SECRET_KEY_BASE tmp_376ea25aaa66984733a90920c263ba138e1e571aaf3a1a54cd2b819cb06e8b7fb311027b639eb8f55d8d53c27cf2df378ceb36008462057861d824bd13a0

# Install build dependencies
RUN apk upgrade
RUN apk add --update --no-cache git bash build-base postgresql-dev libxml2-dev libxslt-dev tzdata nodejs

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY . /usr/src/app
# throw errors if Gemfile has been modified since Gemfile.lock
RUN bundle config build.nokogiri
RUN bundle config --global frozen 1
RUN bundle install --deployment --without development test

# Admin assets
RUN bundle exec rake assets:precompile

# javascript build stage
FROM node:10.5-alpine as js-build-env
MAINTAINER mdouchement franckke

COPY --from=ruby-build-env /usr/src/app /usr/src/app

ENV NODE_ENV production
ENV VUE_APP_MAPBOX_TOKEN pk.eyJ1IjoiZnJhbmNrayIsImEiOiJjamc5ODhrazUzaXlvMndvaDBzMnZoZXF6In0.ThvS99eoVrbmTC_KAmv_6w

WORKDIR /usr/src/app/frontend

RUN yarn install --production=false --frozen-lockfile && yarn cache clean
RUN yarn run build
RUN mv dist/* ../public

# final stage
FROM ruby:2.5-alpine
MAINTAINER mdouchement

# Set the locale
ENV LANG c.UTF-8

# App
ENV GEM_HOME /usr/src/app/vendor/gems
ENV GEM_PATH /usr/src/app/vendor/gems
ENV RAILS_ENV production
ENV RACK_ENV production
ENV EXECJS_RUNTIME Disabled
# Namespace for the application. Necessary for the asset compilation
# Update as needed
# ENV RAILS_RELATIVE_URL_ROOT /mersea
ENV SECRET_KEY_BASE tmp_376ea25aaa66984733a90920c263ba138e1e571aaf3a1a54cd2b819cb06e8b7fb311027b639eb8f55d8d53c27cf2df378ceb36008462057861d824bd13a0

# Install build dependencies
RUN apk upgrade
RUN apk add --update --no-cache postgresql-dev libxml2-dev libxslt-dev tzdata file imagemagick

RUN mkdir -p /usr/src/app
WORKDIR /usr/src/app

COPY --from=js-build-env /usr/src/app /usr/src/app

# Resync bundler
RUN bundle install --deployment --without development test

COPY dockerfiles/nginx.conf /etc/nginx/conf.d/default.conf
VOLUME ["/etc/nginx/conf.d"]

VOLUME ["/usr/src/app/public"]
EXPOSE 3000
CMD SECRET_KEY_BASE=$(bundle exec rake secret) \
    bundle exec puma -p 3000
