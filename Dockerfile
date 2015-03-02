FROM    debian:wheezy
# Install Node.js and npm
RUN     apt-get update && apt-get install -y curl apt-utils
RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN     apt-get install -y nodejs

# Install Java 7 jdk
RUN     apt-get install openjdk-7-jdk

# Install apache web server
RUN     apt-get install -y apache2

# Install neo4j
RUN     wget -O - http://debian.neo4j.org/neotechnology.gpg.key| apt-key add - # Import our signing key
RUN     echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list # Create an Apt sources.list file
RUN     apt-get update -y # Find out about the files in our repository
RUN     apt-get install -y neo4j # Install Neo4j, community edition

# Install redis
RUN     apt-get install -y redis-server
RUN     redis-server &

# Install Maven
RUN     apt-get install -y maven

# Clone and install histograph core
RUN     git clone https://github.com/histograph/core
WORKDIR /core
RUN     mvn clean install
RUN     bin/histograph-core.sh &

# Clone data sets for ingestion
WORKDIR /
RUN     git clone https://github.com/erfgoed-en-locatie/historische-geocoder
RUN /historische-geocoder/histograph-preprocessor.sh

# Clone i/o repo
RUN     git clone https://github.com/histograph/io

# Ingest
RUN     node io/index.js 

# Clone importer
RUN     git clone https://github.com/histograph/import
RUN     node import/index.js