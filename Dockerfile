FROM ruby:2.5

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN gem install nib
