FROM    debian:wheezy
# Install basic dependencies
RUN     apt-get update && apt-get install -y curl apt-utils openjdk-7-jdk apache2 redis-server maven git build-essential
# Install nodejs and npm

RUN     curl -sL https://deb.nodesource.com/setup | bash -
RUN     apt-get install -y nodejs
# Start redis
RUN 	echo "daemonize yes" > redis.conf
RUN     redis-server redis.conf

# Clone config repo and set environment variable
RUN     apt-get install -y git
RUN     git clone https://github.com/histograph/config
ENV     HISTOGRAPH_CONFIG /config/histograph.json
RUN	ls /usr/lib/jvm

# Clone and install histograph core
RUN     git clone https://github.com/histograph/core
WORKDIR /core
RUN     mvn clean install
RUN	java -version
RUN	mvn -v
RUN	javac -version
ENV	JAVA_HOME /usr/lib/jvm/java-7-openjdk-amd64
RUN     bin/histograph-core.sh
RUN	sleep 10
WORKDIR /

# Clone and run API
RUN     git clone https://github.com/histograph/api
WORKDIR /api
RUN     npm install -g forever
RUN     npm install
RUN     forever index.js &
WORKDIR /

# Make ssh dir
RUN mkdir -p /root/.ssh/

# Copy over private key, and set permissions
RUN     echo '\nIf the build fails here, that means that the key authentication for a privat github repository failed.'
RUN     echo 'Please set up key authentication for github as listed on https://help.github.com/articles/generating-ssh-keys/'
RUN     echo 'and make sure the path to the file is listed correctly in the dockerfile.'
ADD     id_rsa /root/.ssh/id_rsa
RUN 	chmod 700 /root/.ssh/id_rsa
RUN echo "Host github.com\n\tStrictHostKeyChecking no\n" >> /root/.ssh/config

# Create known_hosts
RUN     touch /root/.ssh/known_hosts
# Add github key
RUN     ssh-keyscan github.com >> /root/.ssh/known_hosts
# Clone data sets for ingestion

RUN	    git clone git@github.com:erfgoed-en-locatie/historische-geocoder
WORKDIR	/historische-geocoder
RUN	npm install
RUN     ./histograph-preprocessor.sh
WORKDIR /

# Clone and run histograph i/o repo
RUN     git clone https://github.com/histograph/io
WORKDIR /io
RUN     npm install
RUN     node index.js &
WORKDIR /

# Clone importer
RUN     git clone https://github.com/histograph/import
WORKDIR /import
RUN     npm install
RUN     node index.js
