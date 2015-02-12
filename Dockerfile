FROM  debian:wheezy
# Install Node.js and npm
RUN   apt-get update && apt-get install -y curl apt-utils
RUN   curl -sL https://deb.nodesource.com/setup | bash -
RUN   apt-get install -y nodejs

# Install Java 8
RUN   echo "deb http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee /etc/apt/sources.list.d/webupd8team-java.list
RUN   echo "deb-src http://ppa.launchpad.net/webupd8team/java/ubuntu trusty main" | tee -a /etc/apt/sources.list.d/webupd8team-java.list
RUN   apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys EEA14886
RUN   echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections
RUN   apt-get update && apt-get install -y oracle-java8-installer
RUN   apt-get install oracle-java8-set-default

# Install apache web server
RUN   apt-get install -y apache2

# Install tinkerpop
RUN   apt-get install -y wget
RUN   wget -O tinkerpop3.zip https://github.com/tinkerpop/tinkerpop3/archive/3.0.0.M7.zip
RUN   apt-get install -y unzip
RUN   unzip tinkerpop3.zip
RUN   apt-get install -y maven
RUN   mvn -f /tinkerpop3-3.0.0.M7/pom.xml clean install

# Install neo4j
RUN   wget -O - http://debian.neo4j.org/neotechnology.gpg.key| apt-key add - # Import our signing key
RUN   echo 'deb http://debian.neo4j.org/repo stable/' > /etc/apt/sources.list.d/neo4j.list # Create an Apt sources.list file
RUN   apt-get update -y # Find out about the files in our repository
RUN   apt-get install -y neo4j # Install Neo4j, community edition

# Install redis
RUN   apt-get install -y redis-server

# Setup neo4j Gremlin Server
RUN   /tinkerpop3-3.0.0.M7/gremlin-server/bin/gremlin-server.sh -i com.tinkerpop neo4j-gremlin 3.0.0.M7
RUN   /tinkerpop3-3.0.0.M7/gremlin-server/bin/gremlin-server.sh /tinkerpop3-3.0.0.M7/gremlin-server/conf/gremlin-server-neo4j.yaml
