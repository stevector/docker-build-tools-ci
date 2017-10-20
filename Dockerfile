
FROM drupaldocker/php:7.1-cli

# Set the working directory to /build-tools-ci
WORKDIR /build-tools-ci

# Copy the current directory contents into the container at /build-tools-ci
ADD . /build-tools-ci











#FROM debian:sid


# Collect the components we need for this image
RUN apt-get update

# Add node tooling.
# A lot of Drupal/WordPress sites have build processes
# that require these.
RUN apt-get --purge remove node
RUN apt-get --purge remove nodejs
RUN apt-get install -y nodejs
RUN apt-get install -y build-essential
RUN node -v
#RUN apt-get install -y npm
#RUN npm install npm@latest -g
RUN npm --global install yarn
RUN npm install --global gulp-cli




RUN composer -n global require -n "hirak/prestissimo:^0.3"
RUN /usr/bin/env COMPOSER_BIN_DIR=/usr/local/bin composer -n --working-dir=/usr/local/share require pantheon-systems/terminus "^1"
RUN /usr/bin/env COMPOSER_BIN_DIR=/usr/local/bin composer -n --working-dir=/usr/local/share require drush/drush "^8"

env TERMINUS_PLUGINS_DIR /usr/local/share/terminus-plugins
RUN mkdir -p /usr/local/share/terminus-plugins
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-build-tools-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-secrets-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-rsync-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-quicksilver-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-composer-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-drupal-console-plugin:^1
RUN composer -n create-project -d /usr/local/share/terminus-plugins pantheon-systems/terminus-mass-update:^1

