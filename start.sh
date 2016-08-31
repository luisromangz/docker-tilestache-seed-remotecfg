#!/bin/bash

curl $CONFIG_URL > tilestache.zip

if [ ! -e tilestache.zip ]; then
    exit 1
fi

unzip tilestache.zip -d /tmp


sed -i -e "s/%MEMCACHE_PORT_11211_TCP_ADDR%/$MEMCACHE_PORT_11211_TCP_ADDR/g" /tmp/tilestache/tilestache-cfg.json
sed -i -e "s/%MEMCACHE_PORT_11211_TCP_PORT%/$MEMCACHE_PORT_11211_TCP_PORT/g" /tmp/tilestache/tilestache-cfg.json

sed -i -e "s/%SNW_MP_PORT_8080_TCP_ADDR%/$SNW_MP_PORT_8080_TCP_ADDR/g" /tmp/tilestache/tilestache-cfg.json
sed -i -e "s/%SNW_MP_PORT_8080_TCP_PORT%/$SNW_MP_PORT_8080_TCP_PORT/g" /tmp/tilestache/tilestache-cfg.json


cat /tmp/tilestache/tilestache-cfg.json

#tilestache-seed.py -x -b $BBOX -c /tmp/tilestache/tilestache-cfg.json -l $LAYER_NAME $ZOOM_LEVELS

tilestache-list.py -b $BBOX $ZOOM_LEVELS | split -l 20 - /tmp/list-
ls -1 /tmp/list-* | xargs -n1 -P8 tilestache-seed.py -x --enable-retries --error-list=/tmp/tile-errors -c /tmp/tilestache/tilestache-cfg.json -l $LAYER_NAME --tile-list

while [ -e /tmp/tile-errors]; do
    echo "Retrying errors:"
    cat /tmp/tile-errors
    mv /tmp/tile-errors /tmp/tile-errors-input
    tilestache-seed.py -x --enable-retries --error-list=/tmp/tile-errors -c /tmp/tilestache/tilestache-cfg.json -l $LAYER_NAME --tile-list=/tmp/tile-errors-input
done