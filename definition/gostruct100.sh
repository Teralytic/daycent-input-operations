#!/bin/bash

rm data100.go
rm data100

while read line; do
    header=$(echo "$line" | grep -Po ^-.*- | sed -E 's/-//g' | sed -E 's/.*/\u&/')
    trim=$(echo "$line" | grep -Po ^:.*:: | sed -E 's/://g')
    uppercaseTrim=$(echo "$trim" | sed -E 's/.*/\u&/')
    # create struct
    if [ "$header" != "" ]
    then
        echo "}

type $header struct {" >> data100.go
        echo "$header" >> data100

    elif [ "$trim" != "" ]
    then
        echo "    $uppercaseTrim C.int \`json:\"$trim\"\`" >> data100.go
    fi
done < data100.delineated

# post processing
sed -i '1d' data100.go
echo "}" >> data100.go
    echo "
type data100 struct {" >> data100.go

while read line; do
    uppercaseLine=$(echo "$line" | sed -E 's/.*/\u&/')
    echo "  $line $uppercaseLine" >> data100.go
done < data100
echo "}" >> data100.go

rm data100

echo "done with .100 files"

