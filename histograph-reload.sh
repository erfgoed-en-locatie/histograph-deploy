#!/bin/bash
cd /opt/historische-geocoder/
./histograph-preprocessor.sh

rm -r /tmp/histograph
/opt/histograph/core/bin/delete-index.sh

cd opt/histograph/io
node clear-layers.js

cd /opt/histograph/import
node index.js

/opt/histograph/core/bin/histograph-core.sh -v 
