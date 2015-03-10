#!/bin/bash
redis-cli flushall
cd /opt/historische-geocoder/
git pull
./histograph-preprocessor.sh

rm -r /tmp/histograph
/opt/histograph/core/bin/delete-index.sh

cd /opt/histograph/io
node clear-layers.js

cd /opt/histograph/import
# clear logs
rm *.txt
node index.js
