#!/bin/bash

rm data.go

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | sed -E 's/.*/\u&/')
    # create struct
    if [ "$header" != "" ]
    then
        echo "}

type $header struct {" >> data.go

    elif [ "$trim" != "" ]
    then
        echo "    $uppercaseTrim C.int \`json:\"$trim\"\`" >> data.go
    fi
done < delineated

# post processing
sed -i '1d' data.go
echo "}" >> data.go
echo "done"
