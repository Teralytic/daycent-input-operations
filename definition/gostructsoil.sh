#!/bin/bash

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    
    if [ "$header" != "" ]
    then
        echo "found"
    fi
done < soils.delineated