FROM    debian:wheezy
# Install Node.js and npm
RUN     apt-get update && apt-get install -y curl apt-utils
RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN     apt-get install -y nodejs

# Install Java 7 jdk
RUN     apt-get install -y openjdk-7-jdk

# Install apache web server
RUN     apt-get install -y apache2

# Install redis
RUN     apt-get install -y redis-server
RUN     redis-server &

# Install Maven
RUN     apt-get install -y maven

# Clone config repo and set environment variable
RUN     git clone https://github.com/histograph/config
RUN     export HISTOGRAPH_CONFIG='/opt/histograph/config/histograph.json'

# Clone and install histograph core
RUN     apt-get install -y git
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
ADD     id_rsa /root/.ssh/id_rsa
RUN     echo 'If the build fails here, that means that the key authentication for a privat github repository failed.'
RUN     echo 'Please set up key authentication for github and make sure the path to the file is listed correctly in the dockerfile.'

# Create known_hosts
RUN touch /root/.ssh/known_hosts
# Add bitbuckets key
RUN ssh-keyscan github.com >> /root/.ssh/known_hosts
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
