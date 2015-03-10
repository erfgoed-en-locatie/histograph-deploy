#!/bin/bash
export $HISTOGRAPH_CONFIG=/opt/histograph/config/histograph.json
pkill node
cd /opt/histograph
cd api
git pull
npm install
forever index.js
cd ..

cd config
git pull
npm install
cd ..

cd io
git pull
npm install
node clear-layers.js
node index.js &
cd ..

cd import
git pull
npm install
cd ..

cd core
rm *.txt
git pull
mvn clean install



