FROM ruby:3.3.1

RUN gem update --system 3.5.10

WORKDIR /usr/src/app

COPY . /usr/src/app

RUN gem install nib
