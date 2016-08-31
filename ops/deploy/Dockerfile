FROM ruby:2.2-alpine

COPY Gemfile* /tmp/
WORKDIR /tmp

RUN bundle install

COPY . /root/

WORKDIR /root