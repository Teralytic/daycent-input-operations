#!/bin/bash

# build soils struct

rm soils.go

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | tr [a-z] [A-Z])
    
    if [ "$header" != "" ]
    then
        echo "
type $header struct {" >> soils.go

    elif [ "$trim" != "" ]
    then
        echo "$uppercaseTrim C.int \`json:\"$trim\"\`" >> soils.go
    fi
done < soils.delineated

echo "}" >> soils.go
echo "done with soil file"