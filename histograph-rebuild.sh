#!/bin/bash
# export $HISTOGRAPH_CONFIG=/opt/histograph/config/histograph.json
pkill node
cd /opt/histograph/api
git pull
npm install
forever index.js &

cd /opt/histograph/config
git pull
cp histograph.example.json histograph.json

cd /opt/histograph/io
git pull
npm install
node index.js &

cd /opt/histograph/import
git pull
npm install

cd /opt/histograph/core
git pull
mvn clean install

/opt/histograph/core/bin/histograph-core.sh -v 
