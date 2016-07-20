FROM ruby:2.3.0-slim

RUN apt-get -qq update && apt-get install -y build-essential
RUN apt-get install -y git
RUN apt-get install -y libmysqlclient-dev

ENV RAILS_ROOT /var/apps/simpleci
RUN mkdir -p $RAILS_ROOT/tmp/pids

ENV MF_MACHINE musefind22

WORKDIR $RAILS_ROOT

# Use the gemfiles as docker cache markers
RUN ruby -v
RUN gem install bundler --no-ri --no-rdoc
COPY Gemfile Gemfile
COPY Gemfile.lock Gemfile.lock
RUN bundle install --without development test

# copy over the application
COPY . .

RUN bundle install

EXPOSE 3000
CMD ["irb"]
