#!/bin/bash

# build .100 data structs

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
        echo "$uppercaseTrim C.int \`json:\"$trim\"\`" >> data100.go
    fi
done < data100.delineated

# post processing
sed -i '1d' data100.go
echo "}" >> data100.go
    echo "
type Data100 struct {" >> data100-head.go

while read line; do
    lowercaseLine=$(echo "$line" | tr [A-Z] [a-z])
    echo "  $line $line \`json:\"$lowercaseLine\"\`" >> data100-head.go
done < data100
echo "}" >> data100-head.go

cat data100-head.go data100.go > data.go

rm data100
rm data100-head.go
rm data100.go

echo "done with .100 file"

