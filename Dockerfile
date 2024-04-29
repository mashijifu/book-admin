FROM ruby:2.6.6

# Node.jsをインストール
RUN curl -sL https://deb.nodesource.com/setup_18.x | bash - && apt-get install -y nodejs

# yarnパッケージ管理ツールをインストール(m1 macの場合)
RUN wget --quiet -O - /tmp/pubkey.gpg https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - && \
    echo 'deb http://dl.yarnpkg.com/debian/ stable main' > /etc/apt/sources.list.d/yarn.list
RUN set -x && apt-get update -y -qq && apt-get install -yq nodejs yarn

# gem
RUN mkdir /book_admin
WORKDIR /book_admin
COPY Gemfile /book_admin/Gemfile
COPY Gemfile.lock /book_admin/Gemfile.lock
RUN bundle config force_ruby_platform true
RUN bundle install
COPY . /book_admin

# Add a script to be executed every time the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]
EXPOSE 3002

# Configure the main process to run when running the image
CMD ["rails", "server", "-b", "0.0.0.0"]
