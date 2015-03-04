FROM    debian:wheezy
# Install basic dependencies
RUN     apt-get update && apt-get install -y curl apt-utils openjdk-7-jdk apache2 redis-server maven git
# Install nodejs and npm
RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN     apt-get install -y nodejs
# Start redis
RUN     redis-server &

# Clone config repo and set environment variable
RUN     apt-get install -y git
RUN     git clone https://github.com/histograph/config
RUN     export HISTOGRAPH_CONFIG='/opt/histograph/config/histograph.json'

# Clone and install histograph core
RUN     git clone https://github.com/histograph/core
WORKDIR /core
RUN     mvn clean install
RUN     bin/histograph-core.sh &
WORKDIR /

# Clone and run API
RUN     git clone https://github.com/histograph/api
WORKDIR /api
RUN     npm install -g forever
RUN     npm install
RUN     forever index.js &
WORKDIR /

# Make ssh dir
RUN mkdir /root/.ssh/

# Copy over private key, and set permissions
RUN     echo '\nIf the build fails here, that means that the key authentication for a privat github repository failed.'
RUN     echo 'Please set up key authentication for github as listed on https://help.github.com/articles/generating-ssh-keys/'
RUN     echo 'and make sure the path to the file is listed correctly in the dockerfile.'
ADD     ../.ssh/id_rsa /root/.ssh/id_rsa

# Create known_hosts
RUN     touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN     ssh-keyscan github.com >> /root/.ssh/known_hosts
# Clone data sets for ingestion
RUN     git clone git@github.com:erfgoed-en-locatie/historische-geocoder
RUN     /historische-geocoder/histograph-preprocessor.sh

# Clone and run histograph i/o repo
RUN     git clone https://github.com/histograph/io
WORKDIR /io
RUN     mkdir layers
WORKDIR /io/layers
RUN     mkdir atlas-verstedelijking bag carnaval dbpedia gemeentegeschiedenis geonames gewesten militieregisters osm pleiades poorterboeken simon-hart tgn verdwenen-dorpen voc-opvarenden
RUN     npm install
RUN     node index.js &
WORKDIR /

# Clone importer
RUN     git clone https://github.com/histograph/import
WORKDIR /import
RUN     npm install
RUN     node index.js
