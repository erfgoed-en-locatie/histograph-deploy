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

# Clone and run histograph i/o repo
RUN     git clone https://github.com/histograph/io
WORKDIR /io
RUN     npm install
RUN     node index.js &

# Clone data sets for ingestion
WORKDIR /
RUN     git clone https://github.com/erfgoed-en-locatie/historische-geocoder
RUN     /historische-geocoder/histograph-preprocessor.sh

# Clone importer
RUN     git clone https://github.com/histograph/import
WORKDIR /import
RUN     npm install
RUN     node index.js
