#!/bin/bash
# shell script to refresh the indexes and graph, but not to reprocess all source data. The ndjson source data files are expected to be present and correct.
echo 'flush redis queue' 
redis-cli flushall

sudo rm -r /tmp/histograph
/opt/histograph/core/bin/delete-index.sh

cd /opt/histograph/io
node clear-layers.js

# clear logs
sudo rm /opt/histograph/core/*.txt

cd /opt/histograph/import
node index.js
