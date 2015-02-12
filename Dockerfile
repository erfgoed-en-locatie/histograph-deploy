FROM  debian:wheezy
# Install Node.js and npm
RUN   apt-get update && apt-get install -y curl apt-utils
RUN   curl -sL https://deb.nodesource.com/setup | bash -
RUN   apt-get install -y nodejs
# Install Java 7
RUN   apt-get install -y openjdk-7-jre
# Install apache web server
RUN   apt-get install -y apache2
# Install tinkerpop
RUN   apt-get install -y wget
RUN   wget -O tinkerpop3.zip https://github.com/tinkerpop/tinkerpop3/archive/3.0.0.M7.zip
RUN   apt-get install -y unzip
RUN   unzip tinkerpop3.zip
RUN   apt-get install -y maven
